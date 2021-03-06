#INCLUDE "COLORS.CH"
#INCLUDE "FONT.CH"          
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"   
/*
+-----------------------------------------------------------------------+
|Programa  |Par est|    Autor |Juliana                | Data |03.12.2010|
|----------|------------------------------------------------------------|
|Descricao |Parametro para bloqueio de mov estoque..                    |
|          |Atualiza o parametro: MV_ULMES                              |
|----------+------------------------------------------------------------|
| Uso      | Especifico TOPMIX                                          |
|-----------------------------------------------------------------------|
|************************** ALTERA��ES *********************************|
|-----------------------------------------------------------------------|
|PROGRAMADOR | DATA   | MOTIVO DA ALTERACAO                             |
|------------|--------|-------------------------------------------------|
|            |        |                                                 |
+-----------------------------------------------------------------------+
*/         

User Function BloqEst()
/************************************************************************
* Formulario para atualiza��o das msg
*                       
*****/                                 

Local aArrayBtn := {}

Local oTMensBar, oTMsgItem

Private lFormular := .T.
Private cBloqEst  := Space(08)
Private oDlg, oBloqEst 

While(lFormular)
	Define MsDialog oDlg Title "Data Bloqueio Estoque ANOMESDIA Ex:AAAAMMDD - Analisar Virada Saldo SB9" From C(214),C(213) To C(430),C(654) Pixel
	@ C(025),C(008) Say "Data Bloq Est. ANOMESDIA:" Size C(053),C(008) COLOR CLR_HBLUE Pixel Of oDlg
	@ C(035),C(008) MsGet oBloqEst Var cBloqEst Size C(200),C(009) COLOR CLR_BLACK Picture "@!" Pixel Of oDlg

	If(Len(AllTrim(GetMv("MV_ULMES"))) > 8)
		@ C(050),C(008) Say "Data Atual: "+Left(AllTrim(GetMv("MV_ULMES")),75) Size C(250),C(020) COLOR CLR_HRED Pixel Of oDlg 
		@ C(055),C(008) Say SubStr(AllTrim(GetMv("MV_ULMES")),76,120) Size C(250),C(020) COLOR CLR_HRED Pixel Of oDlg
    Else
	   @ C(050),C(008) Say "Data Atual: "+AllTrim(GetMv("MV_ULMES")) Size C(250),C(020) COLOR CLR_HRED Pixel Of oDlg 
   	EndIf                                                                                                                          
  

	oTMensBar := TMsgBar():New(oDlg,"� Topmix - todos os direitos reservados",.F.,.F.,.F.,.F., RGB(116,116,116),,,.F.)      
	oTMsgItem := TMsgItem():New(oTMensBar,"VERS�O: 1.0", 100,,,,.T., {||} ) 
	Activate MsDialog oDlg Centered  On Init EnchoiceBar(oDlg, {||AtualizPar()},{||SaiForm()},,aArrayBtn)
EndDo

Return
                                      

Static Function AtualizPar()
/************************************************************************
* Atualiza os parametros MV_ULMES
*
*****/

Local := lAtualiza := .F. 
  
If(MsgYesNo("Deseja atualizar a data?"))
	PutMv("MV_ULMES",cBloqEst)
	lAtualiza := .T.
EndIf

If(lAtualiza)  
	Aviso("Aten��o", "Data alterada com sucesso...!",{"Ok"},,"Data Bloqueio") 
	SaiForm()
EndIf

Return



Static Function SaiForm()
/************************************************************************
* Rotina para fechar o formulario 
*
*****/

oDlg:End()
lFormular := .F.

Return    



Static Function C(nTam)
/************************************************************************ 
*Funcao responsavel por manter o Layout independente da resolucao horizon
*tal do Monitor do Usuario.                         
*****/         
                                                         
Local nHRes	:=	oMainWnd:nClientWidth	//Resolucao horizontal do monitor     

If(nHRes == 640) //Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)  
	nTam *= 0.8                                                                
ElseIf((nHRes == 798).Or.(nHRes == 800)) //Resolucao 800x600                
	nTam *= 1                                                                  	
Else //Resolucao 1024x768 e acima                                           
	nTam *= 1.28 
	If("P10" $ oApp:cVersion)                                                      
		If((Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild())                      
			nTam *= 0.90                                                            
		EndIf                                                                      
	EndIf                                                                
EndIf                                                                                                                                               
  
Return Int(nTam)                      