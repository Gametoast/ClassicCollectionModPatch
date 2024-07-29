@echo off 
if not exist ..\..\data1\_lvl_pc\ZZ_BACKUP\loading.lvl (

	:: make backup dir 
	mkdir ..\..\data1\_lvl_pc\ZZ_BACKUP\

	:: Backup the lvl
	copy ..\..\data1\_lvl_pc\loading.lvl ..\..\data1\_lvl_pc\ZZ_BACKUP\

	:: Copy it to the 0 folder
	copy ..\..\data1\_lvl_pc\loading.lvl  base.loading.lvl
) else (
	echo Backup folder already created 
)

if not exist base.loading.lvl (
	:: setup for alt addon system 
	echo Something went wrong , please copy loading.lvl to 0\base.loading.lvl
) else (
	echo Looks like setup is done 
)