//
//  main.m
//  Check_and_Modify_machO_symbol
//
//  Created by huke on 5/25/16.
//  Copyright (c) 2016 com.cocoahuke. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <mach-o/nlist.h>
#include <mach-o/loader.h> //mach-o中LC加载命令
#include <mach/machine.h> //mach-o中cpu类型和子类型
#include <mach-o/fat.h>   //mach-o中fat
#include <sys/stat.h>
#include <mach-o/stab.h> //desc

#define FilePath "/Users/huke/Documents/copy zone/parseDisasmKexts_64orig" //导入的文件位置

uint64_t FilegetSize(char *file_path);
uint64_t FilegetSize(char *file_path){
    struct stat buf;
    if ( stat(file_path,&buf) < 0 )
    {
        perror(file_path);
        exit(1);
    }
    return buf.st_size;
}

int main(int argc,const char * argv[]) {
    char *path = FilePath;
    FILE *fp_open = fopen(path,"r");
    uint64_t file_size = FilegetSize(path);
    if(!fp_open){
        printf("file isn't exist\n");
        exit(1);
    }
    printf("file size is 0x%llx\n\n",file_size);
    void *file_buf = malloc(file_size);
    if(fread(file_buf,1,file_size,fp_open)!=file_size){
        printf("fread error\n");
        exit(1);
    }
    fclose(fp_open);
    
    //检查是否为Fat头
    struct fat_header* fileStartAsFat = (struct fat_header*)file_buf;
    if(fileStartAsFat->magic==FAT_CIGAM||fileStartAsFat->magic==FAT_MAGIC){
        printf("is fat\n");
        exit(1);
    }
    
    //检查mach-o文件最前面几个字节的内容.
    struct mach_header *mh = (struct mach_header*)file_buf;
    int is32 = 1;
    
    if(mh->magic==MH_MAGIC||mh->magic==MH_CIGAM){
        is32 = 1;
    }
    else if(mh->magic==MH_MAGIC_64||mh->magic==MH_CIGAM_64){
        is32 = 0;
    }
    
    //遍历cmd中segment和section
    
    const uint32_t cmd_count = mh->ncmds;
    struct load_command *cmds = (struct load_command*)((char*)mh+(is32?sizeof(struct mach_header):sizeof(struct mach_header_64)));
    struct load_command* cmd = cmds;
    for (uint32_t i = 0; i < cmd_count; ++i){
        switch (cmd->cmd) {
            case LC_SYMTAB:{
                struct symtab_command *sym_cmd = (struct symtab_command*)cmd;
                uint32_t symoff = sym_cmd->symoff;
                uint32_t nsyms = sym_cmd->nsyms;
                uint32_t stroff = sym_cmd->stroff;
                uint32_t strsize = sym_cmd->strsize;
                printf("Symbol table is at offset 0x%x (%d), %d entries\n",symoff,symoff,nsyms);
                printf("String table is at offset 0x%x (%d), %d bytes\n",stroff,stroff,strsize);
                printf("\n");
                for(int i =0;i<nsyms;i++){
                    if(is32){
                        //32位
                        struct nlist *nn = (void*)((char*)mh+symoff+i*sizeof(struct nlist));
                        printf("n_strx: 0x%x ",nn->n_un.n_strx);
                        printf("n_type: 0x%x ",nn->n_type);
                        printf("n_sect: 0x%x ",nn->n_sect);
                        printf("n_desc: 0x%x ",nn->n_desc);
                        printf("n_value: 0x%x ",nn->n_value);
                        
                        char *def_str = (char*)mh+(uint32_t)nn->n_un.n_strx + stroff;
                        printf("%s",def_str);
                        
                        if(nn->n_type==0xf||nn->n_type==0xe||nn->n_type==0x1e){
                            //0xf是可以被引用的函数
                            //0xe和0x1e是私有函数,不可以通过dlsym等方法外部引用
                            //这里就是过滤.....修改......
                            //判断条件自己修改
                        }
                        printf("\n");
                    }else{
                        //64位
                        struct nlist_64 *nn = (void*)((char*)mh+symoff+i*sizeof(struct nlist_64));
                        printf("n_strx: 0x%x ",nn->n_un.n_strx);
                        printf("n_type: 0x%x ",nn->n_type);
                        printf("n_sect: 0x%x ",nn->n_sect);
                        printf("n_desc: 0x%x ",nn->n_desc);
                        printf("n_value: 0x%llx ",nn->n_value);
                        
                        char *def_str = (char*)mh+(uint32_t)nn->n_un.n_strx + stroff;
                        printf("%s",def_str);
                        
                        //修改例子
                        /*nn->n_value = 0x0;
                        nn->n_type = 0xF;
                        memset(nn,0xFF,sizeof(struct nlist_64));*/
                        
                        if(nn->n_type==0xf||nn->n_type==0xe||nn->n_type==0x1e){
                            //这里就是过滤.....修改......
                            //判断条件自己修改
                        }
                        printf("\n");
                    }

                    
                    
                    
                }
            }
                break;
        }
        cmd = (struct load_command*)((char*)cmd + cmd->cmdsize);
    }
    
    //这里可以修改mach-o后,并且写回去
    /*FILE *fp_replace = fopen(FilePath,"r+");
     fwrite(file_buf,1,file_size,fp_replace);
     fclose(fp_replace);
     free(file_buf);*/
    return 0;
}

