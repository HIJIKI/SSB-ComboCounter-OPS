;*******************************************************************************
; プロセスメモリ操作モジュール procmem.as
;
;   GetProcID       : プロセスIDを取得する
;   ReadProcMemory  : プロセスメモリの内容を取得する
;   WriteProcMemory : プロセスメモリの内容を変更する
;                                                          最終更新日：2008/11/08
;*******************************************************************************

#module
#uselib "kernel32.dll"
#func CloseHandle@procmem "CloseHandle" sptr
#func OpenProcess@procmem "OpenProcess" sptr,sptr,sptr
#func ReadProcessMemory@procmem "ReadProcessMemory" sptr,sptr,sptr,sptr,sptr
#func WriteProcessMemory@procmem "WriteProcessMemory" sptr,sptr,sptr,sptr,sptr

#uselib "user32.dll"
#func GetWindowThreadProcessId@procmem "GetWindowThreadProcessId" sptr,sptr

#define PROCESS_VM_OPERATION@procmem	$00000008
#define PROCESS_VM_READ@procmem			$00000010
#define PROCESS_VM_WRITE@procmem		$00000020
#define PROCESS_ALL_ACCESS@procnum		$001F0FFF

;*******************************************************************************
;	プロセスIDを取得する
;
;	・書式	GetProcID iWinHandle
;	・引数	(int)iWinHandle : プロセスIDを取得したいウインドウのハンドル
;	・戻り値　失敗：stat = 0 , 成功：stat = プロセスID
;
;*******************************************************************************
#deffunc GetProcID int iWinHandle
	dim result,1
	GetWindowThreadProcessId@procmem iWinHandle , varptr(result)
	return result

;*******************************************************************************
;	プロセスメモリの内容を取得する
;
;	・書式	ReadProcMemory iProcID, iAddress, vReadBuf, iReadSize
;	・引数	(int)iProcID   : プロセスID	
;			(int)iAddress  : メモリアドレス
;			(var)vReadBuf  : 読み込む変数
;			(int)iReadSize : 読み込むバイト数
;	・戻り値　失敗：stat = -1 , 成功：stat = 実際に読み込んだサイズ
;
;*******************************************************************************
#deffunc ReadProcMemory int iProcID,int iAddress ,var vReadBuf ,int iReadSize
	dim procHandle,1
	dim readSize,1
	dim _stat,1
	OpenProcess@procmem PROCESS_VM_READ@procmem, 0, iProcID	:procHandle = stat
	if procHandle == 0 :return -1
	ReadProcessMemory@procmem procHandle,iAddress,varptr(vReadBuf),iReadSize,varptr(readSize)
	_stat = stat
	CloseHandle@procmem procHandle
	if _stat == 0 :return -1
	return readSize

;*******************************************************************************
;	プロセスメモリの内容を変更する
;
;	・書式	WriteProcMemory iProcID, iAddress, vWriteBuf, iWriteSize
;	・引数	(int)iProcID    : プロセスID	
;			(int)iAddress   : メモリアドレス
;			(var)vWriteBuf  : 書き込む内容が入った変数
;			(int)iWriteSize : 書き込むバイト数
;	・戻り値　失敗：stat = -1 , 成功：stat = 実際に書き込んだサイズ
;
;*******************************************************************************
#deffunc WriteProcMemory int iProcID,int iAddress ,var vWriteBuf ,int iWriteSize
	dim procHandle,1
	dim writeSize,1
	OpenProcess@procmem PROCESS_VM_OPERATION@procmem | PROCESS_VM_WRITE@procmem, 0, iProcID	:procHandle = stat
	if procHandle == 0 :return -1
	WriteProcessMemory@procmem procHandle,iAddress,varptr(vWriteBuf),iWriteSize,varptr(writeSize)
	_stat = stat
	CloseHandle@procmem procHandle
	if _stat == 0 :return -1
	return writeSize

#global
