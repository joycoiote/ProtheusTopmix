#include "rwmake.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AGEITAU   �                                                 ���
�������������������������������������������������������������������������͹��
���Descricao � INFOR. A AGENCIA DO FORNECEDOR PARA CNAB A PAGAR DO BANCO  ���
���          � ITAU (SISPAG).                                             ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function AGEFITAU

Local _cAgen
Local _cNumCon
Local _cDac

_cAgen		:= ""
_cNumCon	:= ALLTRIM(SA2->A2_NUMCON)
_cDac		:= ALLTRIM(SA2->A2_DVCTA)


/* //COMENTADA POIS NA DIAGNO EXISTE CAMPOS PR�PRIOS PARA OS D�GITOS.
IF SUBSTR(SA2->A2_NUMCON,LEN(ALLTRIM(SA2->A2_NUMCON))-1,1) = "-"
	_cNumCon	:= SUBSTR(SA2->A2_NUMCON,1,LEN(ALLTRIM(SA2->A2_NUMCON))-2)
	_cDac		:= SUBSTR(SA2->A2_NUMCON,LEN(ALLTRIM(SA2->A2_NUMCON)),1)
ELSE
	IF SUBSTR(SA2->A2_NUMCON,LEN(ALLTRIM(SA2->A2_NUMCON))-2,1) = "-"
		_cNumCon	:= SUBSTR(SA2->A2_NUMCON,1,LEN(ALLTRIM(SA2->A2_NUMCON))-3)
		_cDac		:= SUBSTR(SA2->A2_NUMCON,LEN(ALLTRIM(SA2->A2_NUMCON))-1,2)
	ELSE
		_cNumCon	:= SUBSTR(SA2->A2_NUMCON,1,LEN(ALLTRIM(SA2->A2_NUMCON))-1)
		_cDac		:= SUBSTR(SA2->A2_NUMCON,LEN(ALLTRIM(SA2->A2_NUMCON)),1)
		
	ENDIF
ENDIF
*/


Do Case
	
	Case SA2->A2_BANCO == "341/409" .AND. SEA->EA_MODELO $ "02/10"
		_cAgen := StrZero(Val(SA2->A2_AGENCIA),5)+" "+"00"+StrZero(Val(_cNumCon),10)+" "+"0"
		Return(_cAgen)
		
	Case SA2->A2_BANCO == "341/409" .AND. ! SEA->EA_MODELO $ "02/10"
		_cAgen := StrZero(Val(SA2->A2_AGENCIA),5)+" "+"00"+StrZero(Val(_cNumCon),10)+" "+_cDac
		Return(_cAgen)
		
	Case SA2->A2_BANCO <> "341/409" .and. len(alltrim(_cDac))==1
		_cAgen := StrZero(Val(SA2->A2_AGENCIA),5)+" "+"00"+StrZero(Val(_cNumCon),10)+" "+_cDac
		Return(_cAgen)
		
	OtherWise
		_cAgen := StrZero(Val(SA2->A2_AGENCIA),5)+" "+"00"+StrZero(Val(_cNumCon),10)+_cDac
		Return(_cAgen)
		
EndCase

Return
