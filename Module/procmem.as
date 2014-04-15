;*******************************************************************************
; �v���Z�X���������샂�W���[�� procmem.as
;
;   GetProcID       : �v���Z�XID���擾����
;   ReadProcMemory  : �v���Z�X�������̓��e���擾����
;   WriteProcMemory : �v���Z�X�������̓��e��ύX����
;                                                          �ŏI�X�V���F2008/11/08
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
;	�v���Z�XID���擾����
;
;	�E����	GetProcID iWinHandle
;	�E����	(int)iWinHandle : �v���Z�XID���擾�������E�C���h�E�̃n���h��
;	�E�߂�l�@���s�Fstat = 0 , �����Fstat = �v���Z�XID
;
;*******************************************************************************
#deffunc GetProcID int iWinHandle
	dim result,1
	GetWindowThreadProcessId@procmem iWinHandle , varptr(result)
	return result

;*******************************************************************************
;	�v���Z�X�������̓��e���擾����
;
;	�E����	ReadProcMemory iProcID, iAddress, vReadBuf, iReadSize
;	�E����	(int)iProcID   : �v���Z�XID	
;			(int)iAddress  : �������A�h���X
;			(var)vReadBuf  : �ǂݍ��ޕϐ�
;			(int)iReadSize : �ǂݍ��ރo�C�g��
;	�E�߂�l�@���s�Fstat = -1 , �����Fstat = ���ۂɓǂݍ��񂾃T�C�Y
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
;	�v���Z�X�������̓��e��ύX����
;
;	�E����	WriteProcMemory iProcID, iAddress, vWriteBuf, iWriteSize
;	�E����	(int)iProcID    : �v���Z�XID	
;			(int)iAddress   : �������A�h���X
;			(var)vWriteBuf  : �������ޓ��e���������ϐ�
;			(int)iWriteSize : �������ރo�C�g��
;	�E�߂�l�@���s�Fstat = -1 , �����Fstat = ���ۂɏ������񂾃T�C�Y
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
