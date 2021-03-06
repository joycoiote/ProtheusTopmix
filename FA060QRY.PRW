#include "protheus.ch"

//---------------------------------------------------------------------- 
/*/{Protheus.doc} FA060Qry 
O ponto de entrada FA060QRY permite a inclus�o de uma condi��o adicional 
na consulta SQL (Query) de sele��o dos t�tulos a receber, para posterior 
marca��o em tela. A condi��o adicionada deve seguir a sintaxe SQL e ir� 
interferir na sele��o dos t�tulos a receber que ser�o exibidos em tela.
         
@author	Fernando Ferreira
@since 	25/05/2012
@version	P11 
@obs

/*/ 
//----------------------------------------------------------------------
User Function FA060QRY()

Local cQryRetPrc := FGetQryBco()

Return cQryRetPrc

//---------------------------------------------------------------------- 
/*/{Protheus.doc} FGetQryBco
Expressao SQL de filtro que sera adicionada a clausula WHERE da Query.
         
@author	Fernando Ferreira
@since 	25/05/2012
@version	P11 
@obs

/*/ 
//----------------------------------------------------------------------
Static Function FGetQryBco()

Local		aRet				:= {}
Local 	aPerg				:= {}
Local 	cQryRetPrc 	:= ""
Local 	cNomPrgExe		:= ""
Local		cBcoFilQry		:= ""


cNomPrgExe	:=	"FA060QR"+AllTrim(xFilial())

aadd(aPerg,{1,"Banco"				,CriaVar("A6_COD")           ,"@!","" ,"SA6","",30 ,.F.}) 				// [1]

aPerg[01][03] := ParamLoad(cNomPrgExe,aPerg,01,aPerg[01][03])

If !ParamBox(aPerg,"Parametros",aRet,,,,,,,cNomPrgExe,.T.,.T.) 
	Return Nil	
EndIf

Do Case
	Case !Empty(aRet[01]) .And. AllTrim(aRet[01]) == AllTrim(cPort060)
		cQryRetPrc := " E1_ZBANCO = '"+aRet[01]+"'"
	Case !Empty(aRet[01]) .And. AllTrim(aRet[01]) != AllTrim(cPort060)
		cQryRetPrc := " E1_ZBANCO = '---' AND E1_VALOR = 0"
		MsgInfo("O c�digo banco informado n�o coincide com o c�digo informado na tela anterior. Gentileza reiniciar o processo"," TOTVS ")
	Case Empty(aRet[01])
		cQryRetPrc := " E1_ZBANCO = '"+Space(TamSx3("E1_ZBANCO")[1])+"'"				
EndCase


Return cQryRetPrc


