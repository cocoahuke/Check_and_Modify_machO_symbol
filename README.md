# Check_and_Modify_machO_symbol

这个项目用来检查和修改machO程序的函数符号

具体请看网页
http://cocoahuke.com/2016/05/25/MachO%E6%96%87%E4%BB%B6%E7%9A%84%E7%AC%A6%E5%8F%B7%E6%B7%B7%E6%B7%86/

这个项目并没有提供命令行参数形式,所以请自行在Xcode编译运行

效果
n_strx: 0xb7e3 n_type: 0xe n_sect: 0xb n_desc: 0x0 n_value: 0x1fe2e440 __ZN4dyldL18sDynamicReferencesE
n_strx: 0xb803 n_type: 0xe n_sect: 0xb n_desc: 0x0 n_value: 0x1fe2e44c __ZN4dyldL10sLogToFileE
n_strx: 0xb81b n_type: 0xe n_sect: 0xb n_desc: 0x0 n_value: 0x1fe2e44d __ZN4dyldL26sRemoveImageCallbacksInUseE
n_strx: 0xb843 n_type: 0xe n_sect: 0xb n_desc: 0x0 n_value: 0x1fe2e450 __ZN4dyldL22sDynamicReferencesLockE
n_strx: 0xb867 n_type: 0xe n_sect: 0xb n_desc: 0x0 n_value: 0x1fe2e454 __ZN4dyldL25sDisableAcceleratorTablesE
n_strx: 0xb88e n_type: 0xe n_sect: 0xb n_desc: 0x0 n_value: 0x1fe2e458 __ZZN4dyld20garbageCollectImagesEvE8sDoingGC
n_strx: 0xb8bb n_type: 0xe n_sect: 0xb n_desc: 0x0 n_value: 0x1fe2e459 __ZZN4dyld20garbageCollectImagesEvE5sRedo
n_strx: 0xb8e5 n_type: 0xe n_sect: 0xb n_desc: 0x0 n_value: 0x1fe2e45c __ZN4dyldL18sBundleBeingLoadedE
n_strx: 0xb905 n_type: 0xe n_sect: 0xb n_desc: 0x0 n_value: 0x1fe2e460 __ZN4dyldL33sProcessRequiresLibraryValidationE
n_strx: 0xb934 n_type: 0xe n_sect: 0xb n_desc: 0x0 n_value: 0x1fe2e464 __ZN4dyldL14sAllImagesLockE
n_strx: 0xb950 n_type: 0xe n_sect: 0xb n_desc: 0x0 n_value: 0x1fe2e468 __ZZN4dyldL14parseColonListEPKcS1_E10sEmptyList
n_strx: 0xb980 n_type: 0xe n_sect: 0xb n_desc: 0x0 n_value: 0x1fe2e46c __ZL19sDynamicInterposing

