#INCLUDE "PROTHEUS.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} fValSE2
Valida��o de Campo SE2 

@author	  .iNi Sistemas
@since	  16/03/2014
@version  P11.8
@obs

Alteracoes Realizadas desde a Estruturacao Inicial
Data       Programador     Motivo
/*/
//-------------------------------------------------------------------
User Function fValSE2(cNCampo)

Local aArea 	:= GetArea()
Local lOk := .F.

If AllTrim(cNCampo) == "E2_CODBAR"
	lOk := fValCdb()
EndIf

RestArea(aArea)

Return(lOk)

//-------------------------------------------------------------------
/*/{Protheus.doc} fValCdB
Valida��o de Campo de C�digo de Barras

@author	  .iNi Sistemas
@since	  16/03/2014
@version  P11.8
@obs

Alteracoes Realizadas desde a Estruturacao Inicial
Data       Programador     Motivo
28/04/2014 Jean Santos		Necess�rio somar os campos de Acr�scimo e Subtrair Decr�scimos
/*/
//-------------------------------------------------------------------
Static Function fValCdB()

Local lOk 		:=  .T.
Local cRecCmp 	:= ""
Local dDtBace	:= SuperGetMv("FS_DTBACEN",.T.,"19971007")
Local cCodBar	:= M->E2_CODBAR

If Len(AllTrim(cCodBar)) == 48
	If !(SubStr(AllTrim(cCodBar),1,1) == "8")
		Alert("C�digo de barras de boleto inv�lido. Favor verificar.")
		lOk := .F.
	EndIf
EndIf

If lOk
	If Len(AllTrim(cCodBar)) == 47
		cRecCmp := SubStr(AllTrim(cCodBar),Len(AllTrim(cCodBar))-13,14)
		If Val(cRecCmp) > 0
			If !((M->E2_VENCTO - sTod(dDtBace)) == Val(SubStr(cRecCmp,1,4))) .And. (Val(SubStr(cRecCmp,1,4)) > 0)
				Alert("Data de vencimento divergente do boleto banc�rio. Favor verificar.")
				lOk := .F.
			EndIf
//			If !((Val(SubStr(cRecCmp,5,10))/100) == M->E2_VALOR) .And. (Val(SubStr(cRecCmp,5,10)) > 0) Linha original comentada  - Jean Santos - 28/04/2014
			If !((Val(SubStr(cRecCmp,5,10))/100) == (M->E2_VALOR + M->E2_MULTA + M->E2_JUROS + M->E2_ACRESC - M->E2_DECRESC)) .And. (Val(SubStr(cRecCmp,5,10)) > 0) //Inclu�do a soma dos campos necess�rios - Jean Santos - 28/04/2014
				Alert("Valor do t�tulo divergente do boleto banc�rio. Favor verificar.")
				lOk := .F.
			EndIf
		EndIf
	EndIf
EndIf

Return(lOk)