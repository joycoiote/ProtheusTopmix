#INCLUDE "PROTHEUS.CH"

#DEFINE CAB_ARQTMP  01
#DEFINE CAB_POSATU  02
#DEFINE CAB_SAYGET  03
#DEFINE CAB_HFLD1   04
#DEFINE CAB_HFLD2   05
#DEFINE CAB_HFLD3   06
#DEFINE CAB_MARK    07                                                                                                                   
#DEFINE CAB_GETDAD  08                     
#DEFINE CAB_COTACAO 09
#DEFINE CAB_MSMGET  10
#DEFINE CAB_ULTFORN 11
#DEFINE CAB_HISTORI 12
/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪目北
北矲un噭o    矨160Analis矨utor  矱duardo Riera          � Data �09/08/2000 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪拇北
北矰escri噭o 砇otina de analise das cotacoes de compra                     潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砅arametros矱xpC1: Alias do Arquivo                                      潮�
北�          矱xpN2: Numero do Registro                                    潮�
北�          矱xpN3: Opcao do MBrowse                                      潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砇etorno   砃enhum                                                       潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砋so       砈IGACOM                                                      潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
/*/
*************************************************
User Function A160Analis(cAlias,nReg,nOpcX)      
*************************************************

Local aArea		:= GetArea()
Local aTitles   := {    OemToAnsi("Planilha"),;	//"Planilha"
						OemToAnsi("Auditoria"),;	//"Auditoria"
						OemToAnsi("Fornecedor"),;	//"Fornecedor"
						OemToAnsi("Historico")}		//"Historico"
						
Local aSizeAut	:= {}
Local aObjects	:= {}
Local aInfo 	:= {}
Local aInfo2 	:= {}
Local aPosGet	:= {}
Local aPosObj	:= {}
Local aPosObj3	:= {}
Local aPosObj4	:= {}
Local aRet160PLN:= {}

Local aPlanilha := {}
Local aAuditoria:= {}
Local aCotacao  := {}
Local aListBox  := {}
Local aHeadUltF := {}
Local aRefImpos := {}
Local aCabec	:= {"",0,Array(31,2),Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil} 
Local aCT5      := {}
Local bCtbOnLine:= {||.T.}
Local lProceCot := MV_PAR17==1
Local bPage	    := {}
Local bOk		:= {||IIF(MA160TOK(nOpcX,nReg,aPlanilha,aAuditoria,aCotacao,aCabec,aSC8,aCpoSC8),Eval({|| Eval(bPage,0),nOpcA:=1,IIf(U_A160FeOdlg(lProceCot,@nOpcA,l160Visual,aCabec,aCotacao,aAuditoria),oDlg:End(),.F.)}),.F.)}
//{||IIF(MA160TOK(nOpcX,nReg,aPlanilha,aAuditoria,aCotacao,aCabec,aSC8,aCpoSC8),oDlg:End(),.F.)}
Local bCancel	:= {||oDlg:End()}
Local cLoteCtb  := ""
Local cArqCtb   := ""
Local c652      := ""
Local lSugere	:= MV_PAR01==1 .And. !l160Auto
Local lTes		:= MV_PAR02==1
Local lEntrega	:= MV_PAR03==1                                                                       
Local lDtNeces  := MV_PAR04==1
Local lSelFor   := (MV_PAR05==1 .Or. !lSugere)
Local lBestFor  := MV_PAR09==1
Local lNota     := MV_PAR10==1
Local lCtbOnLine:= MV_PAR11==1 .And. SC7->(FieldPos("C7_DTLANC"))<>0 .And. VerPadrao("652")
Local lAglutina := MV_PAR12==1
Local lDigita   := MV_PAR13==1
Local l160Visual:= aRotina[nOpcX,4] <> 3 .And.aRotina[nOpcX,4] <> 4 .And. aRotina[nOpcX,4] <> 6
Local lMT160ok  := .T.
Local lSigaCus  := .T.
Local nOpcA		:= 0
Local nToler    := MV_PAR08
Local nX		:= 0
Local nY		:= 0
Local nOpcGetd  := nOpcX
Local nHdlPrv   := 0
Local nTotalCtb := 0
Local nScanCot  := 0
Local nPosNumCot:= 0
Local nSaveSX8  := GetSX8Len()
Local nResHor   := IIF(!l160Auto,GetScreenRes()[1],0) //Tamanho resolucao de video horizontal
Local nResVer   := IIF(!l160Auto,GetScreenRes()[2],0) //Tamanho resolucao de video horizontal
Local oDlg
Local oFolder
Local oFont
Local oScroll 
Local cProdCot := ""
Local cItemCotID  := ""
Local cMoeda   := SubStr(GetMv("MV_SIMB"+GetMv("MV_MCUSTO"))+Space(4),1,4)
Local lProd1   := .T.
Local aAreaSC8 := SC8->(GetArea())

Local nScanGrd := 0
Local nScanIte := 0
Local nScanFor := 0
Local nScanLoj := 0
Local nScanNum := 0

Local nPos     := 0
Local nLoop    := 0
Local nLoop1   := 0
Local aCpoSC8  := {}
Local aCtbDia  := {}
Local lContinua:= .T.

Local nPFornSCE := 0
Local nPLojaSCE := 0
Local nPPropSCE := 0
Local nPItemSCE := 0
Local nPQtdeSCE := 0
Local nPUsrQtd  := 0
Local nPUsrItem := 0
Local nPUsrForn := 0
Local nPUsrLoja := 0
Local nPUsrProp := 0
Local nPACCNUM  := 0
Local nPACCITEM := 0
Local aAutItems := {}
Local nItmAuto  := 0
Local nForAuto  := 0
LOcal nForVenc  := 0
Local cCotACC	:= "(SC8->(FieldPos('C8_ACCNUM'))>0 .And. !Empty(SC8->C8_ACCNUM) .And. Empty(SC8->C8_NUMPED))"
Local cCompACC  := ""
Local aDadosACC := {}

// Projeto - botoes F5 e F6 para movimentacao
// guarda as teclas atuais
Local bOldF5 := SetKey(VK_F5)
Local bOldF6 := SetKey(VK_F6)


#IFDEF TOP
	Local cQuery    := ""
	Local cAliasCot := ""
#ENDIF	

PRIVATE aHeader     := {}
PRIVATE aCols       := {}
PRIVATE nMoedaAval  := 1
Private aSC8        := {}
If !lProceCot
	PRIVATE aProds  := {}
Endif
Private lGrava      := .T.
Private nNumPla     := 0
Private cNumCot, cFilCot 

DbSelectArea("SC8")
DbSetOrder (1)
IF dbSeek(aWBrowse2[oWBrowse2:nAt,9]+aWBrowse2[oWBrowse2:nAt,3])
 nReg := Recno()
Endif  
DbGoto(nReg)
cNumCot := SC8->C8_NUM
cFilCot := SC8->C8_FILIAL	

If !l160Auto
	bPage := {|n| Eval(oFolder:bSetOption,1),oFolder:nOption:=1,Ma160Page(n,@aCabec,@aPlanilha,@aAuditoria,@aCotacao,oScroll,lProceCot,aCpoSC8,@oDlg,aPosGet)}
Else
   bPage := {|n| Ma160Page(n,@aCabec,@aPlanilha,@aAuditoria,@aCotacao,oScroll,lProceCot,aCpoSC8)}
EndIf

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Definicao da Estrutura do array aCotaGrade �
//媚哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇
//� 1 - C8_FORNECE                             �
//� 2 - C8_LOJA                                �
//� 3 - C8_NUMPRO                              �
//� 4 - C8_ITEM                                �
//� 5 - C8_PRODUTO (Familia)                   �
//� 6 - Alimentado quando for produto de Grade �
//� 6.1 - C8_PRODUTO                           �
//� 6.2 - CE_QUANT                             �
//� 6.3 - C8_DATPRF                            �
//� 6.4 - C8_ITEMGRD                           �
//� 6.5 - Recno SC8                            �
//� 6.6 - C8_QUANT (Quantidade Original)       �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
PRIVATE aLinGrade := {}
PRIVATE aCotaGrade:= {}
PRIVATE lGrade    := MaGrade()
PRIVATE oGrade	  := MsMatGrade():New('oGrade',,"CE_QUANT",,"A160GValid()",,;
  						{ 	{"CE_QUANT"  ,NIL,NIL},;
							{"CE_ENTREGA",NIL,NIL}, ;
							{"CE_ITEMGRD",NIL,NIL} })
PRIVATE ALTERA    := .T.   // Necessario para o objeto grade
Private aCopSC8   := {}

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
//� Desabilida button Replica do objeto de grade                    |
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
oGrade:lShowButtonRepl := .F.

If FunName() # "RPC" .And. !l160Auto .And. &(cCotACC)
	If nOpcX # 2
		Aviso("Portal ACC","Esta cota玢o poder� ser manipulada somente via portal ACC.",{"Ok"})  //"Portal ACC"#""Esta cota玢o poder� ser manipulada somente via portal ACC.""
		lContinua := .F.
	EndIf
EndIf

If lContinua .And. lSigaCus
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//矱fetua a montagem dos dados referentes ao fornecedor            �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	dbSelectArea("SA2")
	dbSetOrder(1)
	MsSeek(xFilial("SA2")+SC8->C8_FORNECE+SC8->C8_LOJA)
	RegToMemory("SA2",.F.,.T.)
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//矷niciar lancamento do PCO                                       �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	PcoIniLan("000052")
    
    If !lProceCot
		#IFDEF TOP
			dbSelectArea("SC8")
			cAliasCot:= GetNextAlias()
			cQuery := "SELECT DISTINCT C8_PRODUTO, C8_IDENT "
			cQuery += "FROM "+RetSqlName("SC8")+" SC8 "
			cQuery += "WHERE SC8.C8_FILIAL='"+cFilCot+"' AND "
			cQuery += "SC8.C8_NUM='"+cNumCot+"' AND "
			cQuery += "SC8.D_E_L_E_T_=' ' "
			cQuery := ChangeQuery(cQuery)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasCot,.T.,.T.)
			While (cAliasCot)->(!Eof())
			    AADD(aProds,{(cAliasCot)->C8_PRODUTO,(cAliasCot)->C8_IDENT,IIF(lProd1,"X"," "),cNumCot})
			    If lProd1
				    cProdCot := (cAliasCot)->C8_PRODUTO
				    cItemCotID := (cAliasCot)->C8_IDENT
				    lProd1 := .F.
				Endif    
				(cAliasCot)->(dbSkip())
			EndDo
			dbSelectArea(cAliasCot)
			dbCloseArea()
   		#ELSE
   			dbSelectArea("SC8")
   			dbSetOrder(4)
   			dbSeek(xFilial("SC8")+cNumCot)
   			While !Eof() .And. SC8->C8_FILIAL+SC8->C8_NUM == xFilial("SC8")+cNumCot
			    nPos := Ascan(aProds,{|x| x[1]==SC8->C8_PRODUTO .And. x[2]==SC8->C8_IDENT})
			    If nPos == 0
				    AADD(aProds,{SC8->C8_PRODUTO,SC8->C8_IDENT,IIF(lProd1,"X"," "),cNumCot})
				    If lProd1
					    cProdCot := SC8->C8_PRODUTO
					    cItemCotID := SC8->C8_IDENT
					    lProd1 := .F.
					Endif    
				Endif	
	   			dbSkip()
   			EndDo
		#ENDIF
		RestArea(aAreaSC8)
	Endif	
	
	If MultLock("SC8",{cNumCot},1)

		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
		//矱fetua a montagem dos dados a serem exibidos pelo programa      �
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
		If U_MaMontaCot(@aCabec,@aPlanilha,@aAuditoria,@aCotacao,@aListBox,@aRefImpos,lTes,nOpcX==2,lProceCot,cProdCot,cItemCotID,.T.,aSC8,aCpoSC8)

			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//砈eleciona as melhores cotacoes conforme os parametros           �
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			If ( nOpcX == 3 .And. (lSugere .Or. !lSelFor) )
				MaAvCotVen(@aPlanilha,@aCotacao,@aAuditoria,aCABEC[05],lEntrega,nToler,lNota,lBestFor,,aCpoSC8,lSelFor)
			EndIf
			
			dbSelectArea(aCabec[01])      
			
			If !l160Auto	
				aSizeAut := MsAdvSize(,.F.)
		
				aPosGet := MsObjGetPos(aSizeAut[3]-aSizeAut[1],315,{{001,013,070,195,230,295,195,230},;
					{007,038,101,140,204,245,007,038,101,140}, {210,255}, {003,043,096,139,191,218} })
	
				aObjects := {}
				AAdd( aObjects, { 000, 025, .T., .F. } )
				AAdd( aObjects, { 100, 100, .T., .T., .T. } )
				aInfo := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 2, 2 }
				aPosObj := MsObjSize( aInfo, aObjects )
	
				aObjects := {}
				AAdd( aObjects, { 000, 100, .T., .T. } )
				AAdd( aObjects, { 100, 084, .T., .T., .T. } )			
				aInfo2 := { 0, 0, aPosObj[2,3] - 3, aPosObj[2,4] - 13, 2, 2 }	
				aPosObj3 := MsObjSize( aInfo2, aObjects, .T. ) 	
		
				aObjects := {}
				AAdd( aObjects, { 000,100, .T., .T., .T. } )
				AAdd( aObjects, { 000,100, .T., .T., .T. } )	
				aInfo2 := { 129, 0, aPosObj[2,3] - 3, aPosObj[2,4] - 13, 2, 2 }	
				aPosObj4 := MsObjSize( aInfo2, aObjects ) 	
		
				DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD
				DEFINE MSDIALOG oDlg TITLE OemToAnsi("An醠ise de Cota珲es") From aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] OF oMainWnd PIXEL //"An爈ise de Cota嚁es"
		
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//矰efinicao dos Gets do Cabecalho da Area de Trabalho             �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
				DEFINE FONT oFont SIZE 8,0 BOLD
				
				@ 035,aPosGet[1,1] SAY   aCabec[03,1,1] PROMPT RetTitle("C8_PRODUTO") SIZE 22,09 PIXEL OF oDlg
				@ 035,aPosGet[1,2] MSGET aCabec[03,2,1] VAR aCabec[03,2,2] PICTURE PesqPict("SC8","C8_PRODUTO",30) SIZE 105,09 WHEN .F. PIXEL OF oDlg
		
				oScroll := TScrollBox():New( oDlg, 030, aPosGet[1,3] - 10, 25,aPosGet[1,3] + 45)
				@ 05, 02 SAY aCabec[03,3,1] PROMPT aCabec[03,3,2] SIZE 120,80 PIXEL Of oScroll
				aCabec[03,3,1]:Disable()
		
				@ 035,aPosGet[1,4] SAY   aCabec[03,4,1] PROMPT RetTitle("C8_QUANT") SIZE 30,09 PIXEL OF oDlg
				@ 035,aPosGet[1,5] MSGET aCabec[03,5,1] VAR aCabec[03,5,2] PICTURE PesqPict("SC8","C8_QUANT",30) SIZE 64,09 WHEN .F. PIXEL OF oDlg
				@ 035,aPosGet[1,6] SAY   aCabec[03,6,1] PROMPT aCabec[03,6,2] SIZE 30,09 COLOR CLR_BLUE PIXEL OF oDlg FONT oFont
				@ 048,aPosGet[1,7] SAY   aCabec[03,7,1] PROMPT OemToAnsi("Saldo") SIZE 30,09 PIXEL OF oDlg //"Saldo"
				@ 048,aPosGet[1,8] MSGET aCabec[03,8,1] VAR aCabec[03,8,2] PICTURE PesqPict("SC8","C8_QUANT",30) SIZE 64,09 WHEN .F. PIXEL OF oDlg
				
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//矯riacao do Objeto oFolder com os Folders da Analise             �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
				oFolder := TFolder():New(aPosObj[2,1],aPosObj[2,2],aTitles,{"HEADER"},oDlg,,,, .T., .F.,aPosObj[2,3],aPosObj[2,4])
				oFolder:bSetOption:={|x| Ma160Fld(x,oFolder:nOption,oFolder,@aCabec,@aListBox,aPosObj3)}
	
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//矲older 1 - Planilha de Cotacao                                  �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
				aCabec[07]:=MsSelect():New(aCabec[01],"PLN_OK",,aCabec[04],.F.,"XX",{3,3,aPosObj[2,4] - 16,aPosObj[2,3] - 5},,,oFolder:aDialogs[1])
				aCabec[07]:oBrowse:lCanAllMark := .F.
				If ( nOpcX == 3 )
					If ( lSelFor )
						aCabec[07]:bMark := {|| Ma160Marca(@aCabec,@aPlanilha,@aCotacao,oScroll,@aListBox,aCpoSC8) }
					Else
						aCabec[07]:bAval := {|| .T. }
						nOpcGetd := 2
					Endif
				Else
					aCabec[07]:bAval := {|| .T. }
					nOpcGetd := 2
				EndIf	
	
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//矲older 2 - Planilha de Auditoria                                �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			   	aHeader := aCabec[05]
			   	aCols   := aAuditoria[1]
			   	nOpcGetd := GD_INSERT + GD_UPDATE + GD_DELETE
			   	aCabec[08]:=MSNewGetDados():New(3,3,aPosObj[2,4]-16,aPosObj[2,3]-5,nOpcGetd,"Ma160LinOk","","",,,99,,,,oFolder:aDialogs[2],aHeader,aCols)
			    aCabec[08]:oBrowse:bValid := {|lGrava| Ma160VldGd(@aCabec,@aPlanilha,@aCotacao,lGrava,aCpoSC8) }			   
  	            aCabec[08]:oBrowse:nAt := 1
			   //	aCabec[08]:oBrowse:bValid := {|lGrava| Ma160VldGd(@aCabec,@aPlanilha,@aCotacao,lGrava,aCpoSC8) }
	
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//矲older 3 - Planilha do Fornecedor - Informaoes Cadastrais       �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
				aCabec[10]:=MsMGet():New("SA2",SA2->(RecNo()),1,,,,,{aPosObj3[1,1],aPosObj3[1,2],aPosObj3[1,3]+17,aPosObj3[1,4]-155},,2,,,,oFolder:aDialogs[3],,.T.,,,.F.)
	
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//矲older 3 - Gets de Informacoes do Fornecedor.                   �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
				SA2->(dbSetOrder(1))
				SA2->(MsSeek(xFilial("SA2")+(aCabec[01])->PLN_FORNECE+(aCabec[01])->PLN_LOJA))
				@ 013,aPosObj3[1,4]-130 SAY "Saldo Historico"             SIZE 55,9 OF oFolder:aDialogs[3] PIXEL COLOR CLR_BLUE	 //"Saldo Historico"
				@ 027,aPosObj3[1,4]-130 SAY "Maior Compra"+" "+cMoeda  SIZE 55,9 OF oFolder:aDialogs[3] PIXEL COLOR CLR_BLUE	 //"Maior Compra"
				@ 041,aPosObj3[1,4]-130 SAY "Maior Nota"+" "+cMoeda  SIZE 55,9 OF oFolder:aDialogs[3] PIXEL COLOR CLR_BLUE	 //"Maior Nota"
				@ 055,aPosObj3[1,4]-130 SAY "Maior Saldo"+" "+cMoeda  SIZE 55,9 OF oFolder:aDialogs[3] PIXEL COLOR CLR_BLUE	 //"Maior Saldo"
				@ 069,aPosObj3[1,4]-130 SAY "Saldo Historico em"+" "+cMoeda  SIZE 55,9 OF oFolder:aDialogs[3] PIXEL COLOR CLR_BLUE	 //"Saldo Historico em"
				@ 083,aPosObj3[1,4]-130 SAY "Maior Atraso"    SIZE 55,9 OF oFolder:aDialogs[3] PIXEL COLOR CLR_BLUE	 //"Maior Atraso"
				@ 013,aPosObj3[1,4]-070 MSGET aCabec[03,14,1] VAR aCabec[03,14,2] SIZE 53,9 OF oFolder:aDialogs[3] PIXEL When .F. Picture PesQPict("SA2","A2_SALDUP",19)
				@ 027,aPosObj3[1,4]-070 MSGET aCabec[03,15,1] VAR aCabec[03,15,2] SIZE 53,9 OF oFolder:aDialogs[3] PIXEL When .F. Picture PesQPict("SA2","A2_MCOMPRA",19)
				@ 041,aPosObj3[1,4]-070 MSGET aCabec[03,16,1] VAR aCabec[03,16,2] SIZE 53,9 OF oFolder:aDialogs[3] PIXEL When .F. Picture PesQPict("SA2","A2_MNOTA",19)
				@ 055,aPosObj3[1,4]-070 MSGET aCabec[03,17,1] VAR aCabec[03,17,2] SIZE 53,9 OF oFolder:aDialogs[3] PIXEL When .F. Picture PesQPict("SA2","A2_MSALDO",19)
				@ 069,aPosObj3[1,4]-070 MSGET aCabec[03,18,1] VAR aCabec[03,18,2] SIZE 53,9 OF oFolder:aDialogs[3] PIXEL When .F. Picture PesQPict("SA2","A2_SALDUPM",19)
				@ 083,aPosObj3[1,4]-070 MSGET aCabec[03,19,1] VAR aCabec[03,19,2] SIZE 53,9 OF oFolder:aDialogs[3] PIXEL When .F. Picture PesqPictQt("A2_MATR")
				                                                                                                
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//矲older 3 - Botao de consulta da Posicao do Fornecedor           �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
				@ 103,aPosObj3[1,4]-117 BUTTON "Consulta Posicao do Fornecedor" SIZE 100,012 ACTION A160ToFC030(aCabec) OF oFolder:aDialogs[3] PIXEL //"Consulta Posicao do Fornecedor"
	
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//矲older 3 - ListBox das Propostas do Fornecedor para o Produto   �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
				@ aPosObj3[2,1]+17,aPosObj3[2,2] LISTBOX aCabec[09] FIELDS TITLE "" SIZE aPosObj3[2,3],aPosObj3[2,4]-17 OF oFolder:aDialogs[3] PIXEL
				aCabec[09]:aHeaders := aCabec[06]
				aCabec[09]:SetArray(aListBox[1][(aCabec[01])->(RecNo())])
				aCabec[09]:bLine := {|| aCabec[09]:aArray[aCabec[09]:nAT]}
	
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//矲older 4 - Planilha Historico Produto - Gets Estoque Consolidado�
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁     
				// ---- Seta a Posi玢o de acordo com a Resolu玢o do Video --- //
				If !SetMDIChild()
					If nResHor < 1600
					    aPosGet[4,02]:= CalcRes(8,nResHor,,.T.)
					    aPosObj4[1,2]:= CalcRes(8,nResHor,,.T.)+60
					    aPosObj4[2,2]:= CalcRes(8,nResHor,,.T.)+60
					Else
					    aPosGet[4,02]:= CalcRes(6,nResHor,,.T.)
					    aPosObj4[1,2]:= CalcRes(6,nResHor,,.T.)+60
					    aPosObj4[2,2]:= CalcRes(6,nResHor,,.T.)+60			    
					EndIf
				Else
					If nResHor < 1600
					    aPosGet[4,02]:= CalcRes(7,nResHor,,.T.)
					    aPosObj4[1,2]:= CalcRes(7,nResHor,,.T.)+60
					    aPosObj4[2,2]:= CalcRes(7,nResHor,,.T.)+60
					Else
					    aPosGet[4,02]:= CalcRes(5,nResHor,,.T.)
					    aPosObj4[1,2]:= CalcRes(5,nResHor,,.T.)+60
					    aPosObj4[2,2]:= CalcRes(5,nResHor,,.T.)+60
					EndIf
				Endif
				// ---- Seta o tamanho de acordo com o Aspecto da Tela --- //			
				If  ( nResHor/nResVer < 1.4 )//Aspecto 4:3				
					aPosObj4[1,3]:= aPosObj4[1,3]-CalcRes(1,nResHor,,.T.)
					aPosObj4[2,3]:= aPosObj4[2,3]-CalcRes(1,nResHor,,.T.)
				ElseIf ( nResHor/nResVer > 1.7 ) // Aspecto 16:9
					aPosObj4[1,3]:= aPosObj4[1,3]-CalcRes(2,nResHor,,.T.)-10
					aPosObj4[2,3]:= aPosObj4[2,3]-CalcRes(2,nResHor,,.T.)-10
				Else// Aspecto 16:10 e outros
					aPosObj4[1,3]:= aPosObj4[1,3]-CalcRes(2.5,nResHor,,.T.)-10
					aPosObj4[2,3]:= aPosObj4[2,3]-CalcRes(2.5,nResHor,,.T.)-10
				EndIf
				
				@ aPosObj4[1,1]+03,003 SAY "Estoque Consolidado" OF oFolder:aDialogs[4] PIXEL FONT oBold COLOR CLR_RED //"Estoque Consolidado"
				@ aPosObj4[1,1]+13,003 TO aPosObj4[1,1]+14,120 OF oFolder:aDialogs[4] PIXEL 
				@ 019,aPosGet[4,01] SAY "Quantidade Disponivel    " OF oFolder:aDialogs[4] PIXEL //"Quantidade Disponivel    "
				@ 019,aPosGet[4,02] MsGet aCabec[03,20,1] VAR aCabec[03,20,2] Picture PesqPict("SB2","B2_QATU") SIZE 55,08 WHEN .F. PIXEL OF oFolder:aDialogs[4] RIGHT
				@ 033,aPosGet[4,01] SAY "Quantidade Empenhada " OF oFolder:aDialogs[4] PIXEL //"Quantidade Empenhada "
				@ 033,aPosGet[4,02] MsGet aCabec[03,21,1] VAR aCabec[03,21,2] Picture PesqPict("SB2","B2_QEMP") SIZE 55,08 WHEN .F. PIXEL OF oFolder:aDialogs[4] RIGHT
				@ 047,aPosGet[4,01] SAY "Saldo Atual   " OF oFolder:aDialogs[4] PIXEL //"Saldo Atual   "
				@ 047,aPosGet[4,02] MsGet aCabec[03,22,1] VAR aCabec[03,22,2] Picture PesqPict("SB2","B2_QATU") SIZE 55,08 WHEN .F. PIXEL OF oFolder:aDialogs[4] RIGHT
				@ 061,aPosGet[4,01] SAY "Qtd. Entrada Prevista" OF oFolder:aDialogs[4] PIXEL //"Qtd. Entrada Prevista"
				@ 061,aPosGet[4,02] MsGet aCabec[03,23,1] VAR aCabec[03,23,2] Picture PesqPict("SB2","B2_SALPEDI") SIZE 55,08 WHEN .F. PIXEL OF oFolder:aDialogs[4] RIGHT
				@ 075,aPosGet[4,01] SAY "Qtd. Pedido de Vendas  " OF oFolder:aDialogs[4] PIXEL //"Qtd. Pedido de Vendas  "
				@ 075,aPosGet[4,02] MsGet aCabec[03,24,1] VAR aCabec[03,24,2] Picture PesqPict("SB2","B2_QPEDVEN") SIZE 55,08 WHEN .F. PIXEL OF oFolder:aDialogs[4] RIGHT
				@ 089,aPosGet[4,01] SAY "Qtd. Reservada  " OF oFolder:aDialogs[4] PIXEL //"Qtd. Reservada  "
				@ 089,aPosGet[4,02] MsGet aCabec[03,25,1] VAR aCabec[03,25,2] Picture PesqPict("SB2","B2_RESERVA") SIZE 55,08 WHEN .F. PIXEL OF oFolder:aDialogs[4] RIGHT
				@ 103,aPosGet[4,01] SAY "Qtd. Empenhada S.A." OF oFolder:aDialogs[4] PIXEL //"Qtd. Empenhada S.A."
				@ 103,aPosGet[4,02] MsGet aCabec[03,26,1] VAR aCabec[03,26,2] Picture PesqPict("SB2","B2_QEMPSA") SIZE 55,08 WHEN .F. PIXEL OF oFolder:aDialogs[4] RIGHT
				@ 117,aPosGet[4,01] SAY RetTitle("B2_QTNP")    OF oFolder:aDialogs[4] PIXEL
				@ 117,aPosGet[4,02] MsGet aCabec[03,27,1] VAR aCabec[03,27,2] Picture PesqPict("SB2","B2_QTNP") SIZE 55,08 WHEN .F. PIXEL OF oFolder:aDialogs[4] RIGHT
				@ 131,aPosGet[4,01] SAY RetTitle("B2_QNPT")    OF oFolder:aDialogs[4] PIXEL
				@ 131,aPosGet[4,02] MsGet aCabec[03,28,1] VAR aCabec[03,28,2] Picture PesqPict("SB2","B2_QNPT") SIZE 55,08 WHEN .F. PIXEL OF oFolder:aDialogs[4] RIGHT
				@ 145,aPosGet[4,01] SAY RetTitle("B2_QTER")    OF oFolder:aDialogs[4] PIXEL 
				@ 145,aPosGet[4,02] MsGet aCabec[03,29,1] VAR aCabec[03,29,2] Picture PesqPict("SB2","B2_QTER") SIZE 55,08 WHEN .F. PIXEL OF oFolder:aDialogs[4] RIGHT
				@ 159,aPosGet[4,01] SAY RetTitle("B2_QEMPN")   OF oFolder:aDialogs[4] PIXEL 
				@ 159,aPosGet[4,02] MsGet aCabec[03,30,1] VAR aCabec[03,30,2] Picture PesqPict("SB2","B2_QEMPN") SIZE 55,08 WHEN .F. PIXEL OF oFolder:aDialogs[4] RIGHT
				@ 173,aPosGet[4,01] SAY RetTitle("B2_QACLASS") OF oFolder:aDialogs[4] PIXEL 
				@ 173,aPosGet[4,02] MsGet aCabec[03,31,1] VAR aCabec[03,31,2] Picture PesqPict("SB2","B2_QACLASS") SIZE 55,08 WHEN .F. PIXEL OF oFolder:aDialogs[4] RIGHT
		
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//矲older 4 - ListBox da Posicao Analitica do estoque              �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
				@ aPosObj4[1,1]+03,aPosObj4[1,2] SAY "POSI敲O ANALITICA" OF oFolder:aDialogs[4] PIXEL FONT oBold COLOR CLR_RED //"POSI敲O ANALITICA"
				@ aPosObj4[1,1]+13,aPosObj4[1,2] TO aPosObj4[1,1]+14,aPosObj4[1,2]+aPosObj4[1,3] OF oFolder:aDialogs[4] PIXEL 
				@ aPosObj4[1,1]+17,aPosObj4[1,2] LISTBOX aCabec[12] FIELDS TITLE "" SIZE aPosObj4[1,3],aPosObj4[1,4]-17 OF oFolder:aDialogs[4] PIXEL
				aCabec[12]:aHeaders := {"","","","","","","","","",RetTitle("B2_QTNP"),RetTitle("B2_QNPT"),RetTitle("B2_QTER"),RetTitle("B2_QEMPN"),RetTitle("B2_QACLASS")}	
				aCabec[12]:SetArray({Array(14)})
				aCabec[12]:bLine := {|| aCabec[12]:aArray[aCabec[12]:nAt] }
				aCabec[12]:bChange := {|| A160UltFor(aCabec[12]:aArray[aCabec[12]:nAt,2],aCabec) }
	
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//矲older 4 - Botao de consulta do Historico do Produto            �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
				@ 190,aPosGet[4,01] BUTTON "Mais Informacoes do Produto" SIZE 100,012 ACTION A160ComView(aCabec[12]:aArray[aCabec[12]:nAt,2]) OF oFolder:aDialogs[4] PIXEL //"Mais Informacoes do Produto"
	
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//矲older 4 - ListBox dos Ultimos Fornecimentos do Produto         �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
				MaUltForn("",@aHeadUltF)
				@ aPosObj4[2,1]+03,aPosObj4[2,2] SAY "Ultimos Fornecimentos" OF oFolder:aDialogs[4] PIXEL FONT oBold COLOR CLR_RED //"Ultimos Fornecimentos"
				@ aPosObj4[2,1]+13,aPosObj4[2,2] TO aPosObj4[2,1]+14,aPosObj4[2,2]+aPosObj4[2,3] OF oFolder:aDialogs[4] PIXEL 
				@ aPosObj4[2,1]+17,aPosObj4[2,2] LISTBOX aCabec[11] FIELDS TITLE "" SIZE aPosObj4[2,3],aPosObj4[2,4]-17 OF oFolder:aDialogs[4] PIXEL
				aCabec[11]:aHeaders := aHeadUltF
				aCabec[11]:SetArray({aHeadUltF})
				aCabec[11]:bLine := {|| aCabec[11]:aArray[aCabec[11]:nAt] }
	
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//矨certo na movimentacao do folder                                �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
				For nX := 1 to Len(oFolder:aDialogs)
					DEFINE SBUTTON FROM 5000,5000 TYPE 5 ACTION Allwaystrue() ENABLE OF oFolder:aDialogs[nX]
				Next nX
				
				ACTIVATE MSDIALOG oDlg ON INIT Ma160Bar(oDlg,bOk,bCancel,nOpcX,bPage,nReg,aPlanilha,aAuditoria,aCotacao,aListBox,aCabec,aRefImpos,lTes,lProceCot,aSC8,aCpoSC8)
			Else 
				PRIVATE bGetValid := {|lGrava| Ma160VldGd(@aCabec,@aPlanilha,@aCotacao,lGrava,aCpoSC8) }
						
				aHeader := aClone(aCabec[05])
		
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//砎erifica os campos do aCols                                     �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
				nPItemSCE := aScan(aHeader,{|x| Trim(x[2])=="CE_ITEMCOT"}) 
				nPFornSCE := aScan(aHeader,{|x| Trim(x[2])=="CE_FORNECE"})
				nPLojaSCE := aScan(aHeader,{|x| Trim(x[2])=="CE_LOJA"   })
				nPPropSCE := aScan(aHeader,{|x| Trim(x[2])=="CE_NUMPRO" })
				nPQtdeSCE := aScan(aHeader,{|x| Trim(x[2])=="CE_QUANT"  })
		
		
		
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//砎erifica os campos do array da rotina automatica                �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁				
				nPUsrItem := aScan(aAutoItens[1,1],{|x| Trim(x[1])=="CE_ITEMCOT"})
				nPUsrForn := aScan(aAutoItens[1,1],{|x| Trim(x[1])=="CE_FORNECE"})
				nPUsrLoja := aScan(aAutoItens[1,1],{|x| Trim(x[1])=="CE_LOJA"   })
				nPUsrProp := aScan(aAutoItens[1,1],{|x| Trim(x[1])=="CE_NUMPRO" })		
				nPUsrQtd  := aScan(aAutoItens[1,1],{|x| Trim(x[1])=="CE_QUANT"  })
				nPACCNUM  := aScan(aAutoItens[1,1],{|x| Trim(x[1])=="ACCNUM"    })
				nPACCITEM := aScan(aAutoItens[1,1],{|x| Trim(x[1])=="ACCITEM"    })
				
				nOpca := 1
				nX    := 1
				
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//砎arre paginacao da analise                                      �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁				
				While nX <= len(aAuditoria) .And. nOpca == 1
		                	aCols := aClone(aAuditoria[nX])//Carrega aCols com as propostas
		                	
					//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
					//� Posiciona na pagina da analise |
					//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
					Eval(bPage,nX)				
		                  
					//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
					//� Verifica se o item foi informado na rotina automatica          �
					//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
					nItmAuto := aScan(aAutoItens,{|x| x[1,nPUsrItem,2] == aAuditoria[nx,1,nPItemSCE]})
					If nItmAuto > 0
		     					For nY := 1 to Len(aCols)
							//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
							//� Verifica se o fornecedor foi informado na rotina automatica    �
							//� Em caso positivo copia sua quantidade						   �
							//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
							If (nForAuto := aScan(aAutoItens[nItmAuto],{|x| x[nPUsrItem,2]+x[nPUsrForn,2]+x[nPUsrLoja,2]+x[nPUsrProp,2] == aCols[nY,nPItemSCE]+aCols[nY,nPFornSCE]+aCols[nY,nPLojaSCE]+aCols[nY,nPPropSCE]})) > 0
		    	   						aAuditoria[nX][nY][nPQtdeSCE] := aAutoItens[nItmAuto][nForAuto][nPUsrQtd][2]
		    	   						aAdd(aAutItems,aClone(aAutoItens[nItmAuto,nForAuto]))
		    	   						aAdd(aTail(aAutItems),{"LINPOS","CE_FORNECE+CE_LOJA",aAutoItens[nItmAuto][nForAuto][nPUsrForn][2],aAutoItens[nItmAuto][nForAuto][nPUsrLoja][2]})
		    	   						nForVenc := nForAuto
		    	   						If !Empty(nPACCNUM)
		    	   							aAdd(aDadosACC,{nX,nY,nItmAuto,nForAuto})
		    	   						EndIf
		    	  					Else
		    	  						aAdd(aAutItems,aClone(aAutoItens[nItmAuto,1]))
		                  		aTail(aAutItems)[nPUsrItem,2] := aCols[nY,nPItemSCE]
		                  		aTail(aAutItems)[nPUsrForn,2] := aCols[nY,nPFornSCE]
		                  		aTail(aAutItems)[nPUsrLoja,2] := aCols[nY,nPLojaSCE]
		                  		aTail(aAutItems)[nPUsrProp,2] := aCols[nY,nPPropSCE]
		                  		aTail(aAutItems)[nPUsrQtd,2]  := 0
		                  		aAdd(aTail(aAutItems),{"LINPOS","CE_FORNECE+CE_LOJA",aCols[nY,nPFornSCE],aCols[nY,nPLojaSCE]})
		        	          		EndIf
						Next
						
						//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
						//� Posiciona arquivo temporario no |
						//� fornecedor vencedor. 			|
						//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
						While !(aCabec[01])->(EOF())
							If (aCabec[01])->PLN_FORNECE == aAutoItens[nItmAuto][nForVenc][nPUsrForn][2] .And.;
							   (aCabec[01])->PLN_LOJA == aAutoItens[nItmAuto][nForVenc][nPUsrLoja][2]						   
								Exit
							EndIf
							(aCabec[01])->(dbSkip())
						End
						
						If !MsGetDAuto(aAutItems,"Ma160LinOk",,aAutoCab,,.F.)
							nOpca := 0
							Exit
						Else
							nOpca := 1
						EndIf
					EndIf	 			                                
					nX++
					aAutItems := {}
				EndDo
			EndIf

			If ( Select(aCabec[01])<> 0 )
				dbSelectArea(aCabec[01])
				dbCloseArea()
				dbSelectArea("SC8")
			EndIf

		Else
			nOpcA := 0
		EndIf  
	    SC8->(MsUnlockAll())
	Endif
   

	// Projeto - botoes F5 e F6 para movimentacao
	// restaura as teclas
	SetKey(VK_F5,bOldF5)
	SetKey(VK_F6,bOldF6)

	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
	//砇estaura o Array aAuditoria a condicao Original da tabela SC8�
	//砫evido a glutinacao do mesmo para uso de produto de Grade.   �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�	
	If nOpcA == 1 .And. !l160Visual
		aAuditoria := U_A160Audit(aCabec,aAuditoria,aSC8,aCotagrade)
    EndIf

	If nOpcA == 1 .And. !l160Visual
		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�-目
		//� Conforme situacao do parametro abaixo, integra com o SIGAGSP �
		//�             MV_SIGAGSP - 0-Nao / 1-Integra                   �
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪-哪�
		If SuperGetMV("MV_SIGAGSP",.F.,"0") == "1"
			GSPF200(aCotacao)
		EndIf
		
		//-- Tratamentos para o ACC gerar os pedidos de compra
		//-- com o grupo de aprovacao correto e gravando o numero ACC
		If l160Auto .And. (nPos := aScan(aAutoCab,{|x| x[1] == "COMPACC"})) > 0
			cCompACC := aAutoCab[nPos,2]
		EndIf
		
		If !Empty(aDadosACC)
			aEval(aDadosACC, {|x| aAdd(aAuditoria[x[1]][x[2]],aAutoItens[x[3]][x[4]][nPACCNUM][2]),aAdd(aAuditoria[x[1]][x[2]],aAutoItens[x[3]][x[4]][nPACCITEM][2])})
		EndIf
		
		Begin Transaction
			If ( U_MaAvalCOT("SC8",4,aSC8,aCABEC[05],aAuditoria,lDtNeces,Nil,bCtbOnLine,cCompACC) )
				EvalTrigger()
				While ( GetSX8Len() > nSaveSX8 )
					ConfirmSx8()		
				EndDo
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//� Conforme situacao do parametro abaixo, integra com SIGAGSP �
				//� MV_SIGAGSP - 0-Nao / 1-Integra                             �
				//� Para gerar os contratos no GSp                             �
				//� Solicitado por Roberto Mazzarolo em 25/10/2004 por e-mail  �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
				If GetNewPar("MV_SIGAGSP","0") == "1"
					GSPF370(aCotacao,aCABEC[05],aAuditoria)
				EndIf
			Else
				While ( GetSX8Len() > nSaveSX8 )
					RollBackSx8()
				EndDo
			EndIf          		

		End Transaction
	
	Else
		While ( GetSX8Len() > nSaveSX8 )
			RollBackSx8()
		EndDo
		MsUnLockAll()
	EndIf

	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
	//� Finaliza processo de lancamento do PCO                    �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
	PcoFinLan("000052")
	PcoFreeBlq("000052")
	
	If ( Select(aCabec[01])<> 0 )
		dbSelectArea(aCabec[01])
		dbCloseArea()
		dbSelectArea("SC8")
	EndIf
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
	//� Exclui arquivo de trabalho gerado por MontaCot na Comxfun �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
	If File(aCabec[01]+GetDBExtension())
		Ferase(aCabec[01]+GetDBExtension()) 
	Endif
	
EndIf

RestArea(aArea)
Return(.T.)

/*苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐�
北篜rograma  � MA160TOK 篈utor  砊uribio Miranda     � Data � 27/07/10    罕�
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡�
北篋esc.     矲uncao executada no bot鉶 Ok da enchoice Bar do programa    罕�
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北砅arametros� ExpN1: nOpc transmitida pela MBrowse - nOpcX               潮�
北�          � ExpN2: Numero do registro - nReg                           潮�
北�          � ExpA1: Array de planilhas de cotacao - aPlanilha           潮�
北�          � ExpA2: Array de auditorias - aAuditoria					  潮�
北�          � ExpA3: Array de cotacao - aCotacao	  					  潮�
北�          � ExpA3: Array de cotacao - aCotacao	  					  潮�
北�          � ExpA5: Array de campos considerados da SC8 - aSC8		  潮�
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北篣so       � MATA160								  	 	              罕�
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�*/
Static Function MA160TOK(nOpcX,nReg,aPlanilha,aAuditoria,aCotacao,aSC8)

Local lRet		:= .T.
Local nProd		:= aScan(aCotacao[1][1],{|x| Trim(x[1])=="C8_PRODUTO"})
Local nX		:= 0
Local cProd		:= ""
Local aAreaSB1	:= SB1->(GetArea())

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Checa se produto est� bloqueado                    �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
If lRet
	For nX := 1 To Len(aCotacao)
		cProd := aCotacao[nX][1][nProd][2]
		dbSelectArea("SB1")
		dbSetOrder(1)
		If MsSeek(xFilial("SB1")+cProd)
			If !RegistroOk("SB1")
				lRet := .F.
				Exit
			EndIf
		EndIf
	Next nX
EndIf

RestArea(aAreaSB1)

Return lRet



/*苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐�          
北篜rograma  矯alcRes   篈utor  砊uribio Miranda     � Data �  01/07/10   罕�
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡�
北篋esc.     矲uncao que transforma um percentual da tela em pixels confor罕�
北�          砿e a resolucao de video utilizada                           罕�
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北篜arametros硁Perc   - Valor em percentual de video desejado		      罕�
北�          硁ResHor - Resolucao Horizontal de referencia				  罕�
北�          硁ResVer - Resolucao Vertical de referencia  		     	  罕�
北�          砽Widht  - Flag para controlar se a medida e vertical ou horz罕�
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北篣so       � MATA160								  	 	              罕�
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�*/
Static Function CalcRes(nPerc,nResHor,nResVer,lWidth)
Local nRet

DEFAULT	nResHor:= GetScreenRes()[1]
DEFAULT nResVer:= GetScreenRes()[2]

if lWidth
	nRet := nPerc * nResHor / 100
else
	nRet := nPerc * nResVer / 100
endif

Return nRet  

/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲uncao    矼a160Bar  � Autor � Eduardo Riera         � Data �09.08.2000潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噮o � EnchoiceBar especifica do Mata160                          潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砇etorno   � Nenhum                                                     潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros� ExpO1: Objeto Dialog                                       潮�
北�          � ExpB2: Code Block para o Evento Ok                         潮�
北�          � ExpB3: Code Block para o Evento Cancel                     潮�
北�          � ExpN4: nOpc transmitido pela mbrowse                       潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
/*/
Static Function Ma160Bar(oDlg,bOk,bCancel,nOpc,bPage,nReg,aPlanilha,aAuditoria,aCotacao,aListBox,aCabec,aRefImpos,lTes,lProceCot,aSC8,aCpoSC8)

Local aButtons    := {}
Local aButtonUsr  := {}
Local nX		  := {}
Local cPrinter    := GetNewPar("MV_IMPRCOT"," ")
Local lMa160Imp   := IIf(!Empty( cPrinter ) .And. Existblock( cPrinter ),.T.,.F.)

DEFAULT aCpoSC8   := {}

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Adiciona os botoes padroes                                             �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
aadd(aButtons,{"PMSPRINT",{|| IIF(!lMa160Imp,MA160Imp(aPlanilha,aAuditoria,aCotacao,aListBox,aCabec,aRefImpos,lTes,aCpoSC8),ExecBlock( cPrinter, .F., .F., {nReg,aPlanilha,aAuditoria,aCotacao,aListBox,aCabec,aRefImpos,lTes,aCpoSC8} )) },OemToAnsi(""),OemToAnsi("") })  

If lProceCot
	aadd(aButtons,{"PREV"    ,{|| Eval(bPage,-1)},OemToAnsi("Anterior"),OemToAnsi("Anterior")})	//"Anterior"
	aadd(aButtons,{"NEXT"    ,{|| Eval(bPage,+1)},OemToAnsi("Proximo"),OemToAnsi("Proximo")})	//"Proximo"

	// Projeto - botoes F5 e F6 para movimentacao
	// seta as teclas para realizar a movimentacao
  	SetKey(VK_F5, {|| Eval(bPage,-1)}) 	//"Anterior"       
    SetKey(VK_F6, {|| Eval(bPage,+1)}) 	//"Proximo"

Else
	aadd(aButtons,{"PREV"    ,{|| M160PRVNXT(.T.,aPlanilha,aAuditoria,aCotacao,aListBox,aCabec,aRefImpos,lTes,nOpc,bPage,lProceCot,aSC8,aCpoSC8)},OemToAnsi("Anterior"),OemToAnsi("Anterior")})	//"Anterior"
	aadd(aButtons,{"NEXT"    ,{|| M160PRVNXT(.F.,aPlanilha,aAuditoria,aCotacao,aListBox,aCabec,aRefImpos,lTes,nOpc,bPage,lProceCot,aSC8,aCpoSC8)},OemToAnsi("Proximo"),OemToAnsi("Proximo")})	//"Proximo"

	// Projeto - botoes F5 e F6 para movimentacao
	// seta as teclas para realizar a movimentacao
   	SetKey(VK_F5, {|| M160PRVNXT(.T.,aPlanilha,aAuditoria,aCotacao,aListBox,aCabec,aRefImpos,lTes,nOpc,bPage,lProceCot,aSC8,aCpoSC8)}) 	//"Anterior"
  	SetKey(VK_F6, {|| M160PRVNXT(.F.,aPlanilha,aAuditoria,aCotacao,aListBox,aCabec,aRefImpos,lTes,nOpc,bPage,lProceCot,aSC8,aCpoSC8)}) 	//"Proximo"

Endif	

Eval(bPage,1)

Return(EnchoiceBar(oDlg,bOK,bCancel,,aButtons))   

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪目北
北矲un噭o    矼a160Fld  矨utor  矨lexandre Inacio Lemes � Data �11/06/2007 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪拇北
北矰escri噮o 矲uncao de Tratamento dos Folders                             潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砅arametros矱xpN1: Numero do Folder de Destino                           潮�
北�          矱xpN2: Numero do Folder Atual                                潮�
北�          矱xpO3: Objeto do Folder                                      潮�
北�          矱xpA4: Array contendo todos objetos da analise               潮�
北�          矱xpA5: Array contendo os elementos da listbox do Folder 3    潮�
北�          矱xpA6: Array contendo as posicoes dos Gets do Folder 3       潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砋so       矼ATA160                                                      潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
/*/
Static Function Ma160Fld(nFldDst,nFldAtu,oFolder,aCabec,aListbox,aPosObj3)

Local aArea		 := GetArea()
Local aUltForn   := {}
Local aViewSB2   := {}
Local bCampo     := { |n| FieldName(n) }
Local cProduto   := ""
Local nPosAtu    := aCabec[02]
Local nX         := 0
Local nR         := 0
Local nSaldo     := 0
Local nDuracao   := 0
Local nTotDisp	 := 0
Local nQtPV		 := 0
Local nQemp		 := 0
Local nSalpedi	 := 0
Local nReserva	 := 0
Local nQempSA	 := 0
Local nQtdTerc	 := 0
Local nQtdNEmTerc:= 0
Local nSldTerc	 := 0                                                       
Local nQEmpN	 := 0
Local nQAClass	 := 0
Local nScan      := 0
Local nSaldoSB2  := 0
Local lSigaCus   := .T.

DEFAULT aCabec[11]:CARGO := ""

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
//� Funcao utilizada para verificar a ultima versao dos fontes      �
//� SIGACUS.PRW, SIGACUSA.PRX e SIGACUSB.PRX, aplicados no rpo do   |
//| cliente, assim verificando a necessidade de uma atualizacao     |
//| nestes fontes. NAO REMOVER !!!							        �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
IF !(FindFunction("SIGACUS_V") .and. SIGACUS_V() >= 20050512)
   //	Aviso(STR0027,STR0029,{STR0028}) //"Atualizar patch do programa SIGACUS.PRW !!!"
	lSigaCus := .F.
EndIf
IF !(FindFunction("SIGACUSA_V") .and. SIGACUSA_V() >= 20050512)
  //	Aviso(STR0027,STR0030,{STR0028}) //"Atualizar patch do programa SIGACUSA.PRW !!!"
	lSigaCus := .F.
EndIf
IF !(FindFunction("SIGACUSB_V") .and. SIGACUSB_V() >= 20050512)
  //	Aviso(STR0027,STR0031,{STR0028}) //"Atualizar patch do programa SIGACUSB.PRW !!!"
	lSigaCus := .F.
EndIf

If lSigaCus
	
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//矱fetua a atualizacao dos dados na Troca dos Folders                     �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	If ( nFldDst <> nFldAtu )

		aCabec[07]:oBrowse:lDisablePaint := .T.
		aCabec[08]:oBrowse:lDisablePaint := .T.
		aCabec[09]:lDisablePaint := .T.
		aCabec[11]:lDisablePaint := .T.
		
		Do Case
			
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//� Folder 1 - Planilha Analisar - Efetua a atualizacao dos dados do Folder�
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			Case ( nFldDst == 1 )
				
				aCabec[07]:oBrowse:lDisablePaint := .F.
				aCabec[07]:oBrowse:Reset()
				
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//� Folder 2 - Auditoria - Efetua a atualizacao dos dados do Folder        �
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			Case ( nFldDst == 2 )
				
				aCabec[08]:oBrowse:lDisablePaint := .F.
				
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//� Folder 3 - Fornecedor - Efetua a atualizacao dos dados do Folder       �
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			Case ( nFldDst == 3 )
				
				aCabec[09]:lDisablePaint := .F.
				dbSelectArea("SA2")
				dbSetOrder(1)
				MsSeek(xFilial("SA2")+(aCabec[01])->PLN_FORNECE+(aCabec[01])->PLN_LOJA)
				If ( M->A2_COD <> (aCabec[01])->PLN_FORNECE .Or.;
					M->A2_LOJA <> (aCabec[01])->PLN_LOJA )
					For nX := 1 To FCount()
						M->&(EVAL(bCampo,nX)) := FieldGet(nX)
					Next nX
					aCabec[10]:EnchRefreshAll()
				EndIf
				aCabec[03,14,2]:= SA2->A2_SALDUP
				aCabec[03,15,2]:= SA2->A2_MCOMPRA
				aCabec[03,16,2]:= SA2->A2_MNOTA
				aCabec[03,17,2]:= SA2->A2_MSALDO
				aCabec[03,18,2]:= SA2->A2_SALDUPM
				aCabec[03,19,2]:= SA2->A2_MATR
				
				aCabec[09]:SetArray(aListBox[nPosAtu][(aCabec[01])->(RecNo())])
				aCabec[09]:bLine := {|| aCabec[09]:aArray[aCabec[09]:nAT]}
				aCabec[09]:Refresh()
				
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//� Folder 4 - Historico do Produto e Estoques - Atualiza os Dados         �
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			Case ( nFldDst == 4 )
				
				aCabec[11]:lDisablePaint := .F.
				If aCabec[11]:CARGO <> aCabec[03,2,2]
					
					nScan := aScan( aCotaGrade, { |x| x[5] == aCabec[3,2,2] } )
					
					For nX := 1 to IIF( Len(aCotaGrade[nScan,6]) > 0 , Len(aCotagrade[nScan,6]) , 1 )

						If Len(aCotaGrade[nScan,6]) > 0
							cProduto := aCotagrade[nScan,6,nX,1]
						Else
							cProduto := aCabec[03,2,2]                                              
						EndIf
						
						dbSelectArea("SB2")
						dbSetOrder(1)
						MsSeek(xFilial("SB2")+cProduto)
						While !Eof() .And. xFilial("SB2")+cProduto == SB2->B2_FILIAL+SB2->B2_COD
							If !(SB2->B2_STATUS == '2')
								
								If SB2->B2_LOCAL < MV_PAR15 .Or. SB2->B2_LOCAL > MV_PAR16
									dbSkip()
									Loop
								EndIf
								
								nSaldoSB2:=SaldoSB2(,,,,,"SB2")
								
								aAdd(aViewSB2,{TransForm(SB2->B2_LOCAL,PesqPict("SB2","B2_LOCAL")),;
								TransForm(SB2->B2_COD,PesqPict("SB2","B2_COD")),;
								TransForm(nSaldoSB2,PesqPict("SB2","B2_QATU")),;
								TransForm(SB2->B2_QATU,PesqPict("SB2","B2_QATU")),;
								TransForm(SB2->B2_QPEDVEN,PesqPict("SB2","B2_QPEDVEN")),;
								TransForm(SB2->B2_QEMP,PesqPict("SB2","B2_QEMP")),;
								TransForm(SB2->B2_SALPEDI,PesqPict("SB2","B2_SALPEDI")),;
								TransForm(SB2->B2_QEMPSA,PesqPict("SB2","B2_QEMPSA")),;
								TransForm(SB2->B2_RESERVA,PesqPict("SB2","B2_RESERVA")),;
								TransForm(SB2->B2_QTNP,PesqPict("SB2","B2_QTNP")),;
								TransForm(SB2->B2_QNPT,PesqPict("SB2","B2_QNPT")),;
								TransForm(SB2->B2_QTER,PesqPict("SB2","B2_QTER")),;
								TransForm(SB2->B2_QEMPN,PesqPict("SB2","B2_QEMPN")),;
								TransForm(SB2->B2_QACLASS,PesqPict("SB2","B2_QACLASS"))})
								
								nTotDisp	+= nSaldoSB2
								nSaldo		+= SB2->B2_QATU
								nQtPV		+= SB2->B2_QPEDVEN
								nQemp		+= SB2->B2_QEMP
								nSalpedi	+= SB2->B2_SALPEDI
								nReserva	+= SB2->B2_RESERVA
								nQempSA		+= SB2->B2_QEMPSA
								nQtdTerc	+= SB2->B2_QTNP
								nQtdNEmTerc	+= SB2->B2_QNPT
								nSldTerc	+= SB2->B2_QTER
								nQEmpN		+= SB2->B2_QEMPN
								nQAClass	+= SB2->B2_QACLASS
								
							EndIf
							dbSelectArea("SB2")
							dbSkip()
						EndDo
						
					Next nX

					aCabec[12]:SetArray(aViewSB2)
					aCabec[12]:bLine := {|| aCabec[12]:aArray[aCabec[12]:nAt] }
					aCabec[12]:Refresh()
					
					aCabec[03,20,2] := nTotDisp
					aCabec[03,21,2] := nQemp
					aCabec[03,22,2] := nSaldo
					aCabec[03,23,2] := nSalPedi           
					aCabec[03,24,2] := nQtPv
					aCabec[03,25,2] := nReserva
					aCabec[03,26,2] := nQEmpSA
					aCabec[03,27,2] := nQtdTerc
					aCabec[03,28,2] := nQtdNEmTerc
					aCabec[03,29,2] := nSldTerc
					aCabec[03,30,2] := nQEmpN
					aCabec[03,31,2] := nQAClass

				   	U_A160UltFor(aCabec[12]:aArray[aCabec[12]:nAt,2],aCabec)
					
				EndIf
				
		EndCase
		
	EndIf
	
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//� Efetua Refresh nos Objetos da Getdados da Auditoria e Todos SayGets    �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	aCabec[08]:oBrowse:Refresh()
	
	For nR :=14 to Len(aCabec[03])
		aCabec[03,nR,1]:Refresh()
	Next nR
	
EndIf

RestArea(aArea)

Return(.T.)

/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲uncao    矼a160Page � Autor � Eduardo Riera         � Data �10.08.2000潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噮o �                                                            潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砇etorno   � Nenhum                                                     潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros� ExpO1:                                                     潮�
北�          � ExpB2:                                                     潮�
北�          � ExpB3:                                                     潮�
北�          � ExpN4:                                                     潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
/*/
Static Function Ma160Page(nSoma,aCabec,aPlanilha,aAuditoria,aCotacao,oScroll,lProceCot,aCpoSC8,oDlg,aPosGet)

Local aArea   	  := GetArea()
Local cCodPro     := ""
Local cDescPro    := ""
Local cAlias      := aCabec[01]
Local nPosAtu     := If(!l160Auto,aCabec[02],nSoma)
Local nPosAnt     := nPosAtu
Local nPNumSC     := aScan(aCotacao[1][1],{|x| Trim(x[1])=="C8_NUMSC"})
Local nPItemSC    := aScan(aCotacao[1][1],{|x| Trim(x[1])=="C8_ITEMSC"})
Local nPItemGrd   := aScan(aCotacao[1][1],{|x| Trim(x[1])=="C8_ITEMGRD"})
Local nPQtdSC8    := aScan(aCotacao[1][1],{|x| Trim(x[1])=="C8_QUANT"})
Local nPGrdSC8    := aScan(aCotacao[1][1],{|x| Trim(x[1])=="C8_GRADE"})
Local nPQtdSCE    := aScan(aCabec[05],    {|x| Trim(x[2])=="CE_QUANT"})
Local nPProd      := aScan(aCotacao[1][1],{|x| Trim(x[1])=="C8_PRODUTO"})
Local nSaldo      := 0
Local nX		  := 0
Local nY	  	  := 0
Local lValido     := .T.
Local lReferencia := Nil
Local lVldQuant   := GetNewPar("MV_DIFQTDC","N") == "N" .And. If(Type('lIsACC')#"L",.T.,!lIsACC)

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Executa a validacao do Saldo a Distribuir da pagina atual do Folder    �
//� Auditoria. O Par.MV_DIFQTDC usado para permitir que a analise gere PCs �
//� mesmo que exista saldo a distribuir so tera efeito com produtos que nao�
//� usem grade de produto, caso contrario so proseguira a analise quando   �
//� nao existir mais saldo a distribuir para os produtos de grade.         �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
If ( nPosAnt <> 0 )
	For nX := 1 To Len(aCols)
		nSaldo += aCols[nX][nPQtdSCE]
	Next nX
	If lVldQuant .Or. aCotacao[nPosAnt][1][nPGrdSC8][2] == "S"
		If ( nSaldo <> aCotacao[nPosAnt][1][nPQtdSC8][2] .And. nSaldo > 0 )
			lValido := .F.	
		EndIf
	Else
		If ( nSaldo > aCotacao[nPosAnt][1][nPQtdSC8][2] .And. nSaldo > 0 )
  			lValido := .F.	
		EndIf
	Endif	
	nSaldo := 0
EndIf

If lValido 
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//� Ajusta a nova posicao atual                                            �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁  
	If !l160Auto
		nPosAtu += nSoma
	Else
		nPosAtu := nSoma
	EndIf
	nPosAtu := Min(nPosAtu,Len(aPlanilha))
	nPosAtu := Max(1,nPosAtu)
	aCabec[02] := nPosAtu	
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//� Calcula o saldo restante a ser selecionado                             �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	nSaldo := 0
	For nX := 1 To Len(aAuditoria[nPosAtu])
		nSaldo += aAuditoria[nPosAtu][nX][nPQtdSCE]
	Next nX

	nSaldo := aCotacao[nPosAtu][1][nPQtdSC8][2] - nSaldo

	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//� Limpa o arquivo temporario                                             �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	dbSelectArea(cAlias)
	ZAP
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//� Atualiza os dados da Planilha de cotacao                               �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	For nX := 1 To Len(aPlanilha[nPosAtu])
		RecLock(cAlias,.T.)
		For nY := 1 To FCount()
		 If (nY == 5 .OR. nY == 6 .OR. nY == 7 .OR. nY == 10 .OR. nY == 11 .OR. nY == 14 .OR. nY == 15 .OR. nY == 18 )   
		  FieldPut(nY,aPlanilha[nPosAtu][nX][nY]) 
		 Else
		  FieldPut(nY,CVALTOCHAR(aPlanilha[nPosAtu][nX][nY]))	
		 Endif
		Next nY
		MsUnLock()
	Next nX         
	If !l160Auto
		aCabec[07]:oBrowse:GoTop()
		aCabec[07]:oBrowse:Refresh()
	EndIf
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//� Atualiza os dados da Planilha de auditoria                             �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	N := 1
	If ( nPosAnt <> 0 )
		If !l160Auto
			aCabec[08]:oBrowse:lDisablePaint := .T. 
		EndIf
		aAuditoria[nPosAnt] := aClone(aCols)
		aCols := aClone(aAuditoria[nPosAtu])
		If !l160Auto
			aCabec[08]:oBrowse:lDisablePaint := .F.
			aCabec[08]:oBrowse:Refresh()
		EndIf
	EndIf
	
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//� Atualiza os dados do cabecalho da analise da cotacao                   �
	//| Caso n鉶 existir a SC1, busca a descri玢o da SB1 ou SB5                |
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	dbSelectArea("SC1")
	dbSetOrder(1)
	If MsSeek(xFilial("SC1")+aCotacao[nPosAtu][1][nPNumSC][2]+aCotacao[nPosAtu][1][nPItemSC][2])
		cCodPro  := SC1->C1_PRODUTO
		cDescPro := SC1->C1_DESCRI
	Else
		cCodPro  := aCotacao[nPosAtu][1][nPProd][2]
		dbSelectArea("SB1")
		dbSetOrder(1)
		If MsSeek(xFilial("SB1")+cCodPro)    
			cDescPro := SB1->B1_DESC
			dbSelectArea("SB5")
			dbSetOrder(1)
			If MsSeek(xFilial("SB5")+cCodPro) 
				cDescPro := SB5->B5_CEME
			EndIf
		EndIf
	EndIf

	If lGrade .And. !Empty(aCotacao[nPosAtu][1][nPItemGrd][2])
		If (lReferencia := MatGrdPrRf(@cCodPro,.T.))
			cCodPro  := RetCodProdFam(SC1->C1_PRODUTO)
			cDescPro := DescPrRF(cCodPro)
		Endif
	Endif
	
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
	//� Atribuido o codigo do produto a variavel PUBLICA VAR_IXB para uso em ponto de entrada �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�

	VAR_IXB :={}
	aAdd(VAR_IXB,{"PRODUTO", cCodPro}) 
	
	If !l160Auto
		aCabec[03,2,2] := cCodPro	//Codigo do Produto
		aCabec[03,2,1] :Refresh()
	
		aCabec[03,3,1]:SetText( Transform( cDescPro, PesqPict("SC8","C8_DESCRI",30) ) )
		oScroll:Reset()
	
		aCabec[03,5,2] := aCotacao[nPosAtu][1][nPQtdSC8][2] //Quantidade
		aCabec[03,5,1] :Refresh()
		If lProceCot
			aCabec[03,6,1] :cCaption := StrZero(nPosAtu,3)+"/"+StrZero(Len(aPlanilha),3) //Ordem
		Else	
			aCabec[03,6,1] :cCaption := StrZero(nPosAtu,3)+"/"+StrZero(Len(aProds),3) //Ordem
		Endif	
		aCabec[03,6,1] :Refresh()
	
		aCabec[03,8,2] := nSaldo //Saldo
		aCabec[03,8,1] :Refresh()
	EndIf
Else
	Help(" ",1,"QTDDIF")
EndIf	

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//矼onta a Grade para o Produto Analisado.                         �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
A160ColsGrade(aCabec[03,2,2], .T.)

If !l160Auto
	aCabec[08]:oBrowse:refresh()
EndIf

RestArea(aArea)

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//矨o trocar o produto mantem sempre a MarkBrowse posicionada no   �
//硁o inicio do Arquivo independente do fornecedor selecionado.    �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
(calias)->(Dbgotop())

Return(.T.) 

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪目北
北矲un噭o    矼a160Marca矨utor  矱duardo Riera          � Data �09.08.2000 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪拇北
北矰escri噭o �                                                             潮�
北�          �                                                             潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砅arametros矱xpC1:                                                       潮�
北�          矱xpN2:                                                       潮�
北�          矱xpN3:                                                       潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砇etorno   砃enhum                                                       潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砋so       砈IGACOM                                                      潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
/*/
Static Function Ma160Marca(aCabec,aPlanilha,aCotacao,oScroll,aListBox,aCpoSC8)

Local aArea    	 := GetArea()
Local cCodPro  	 := ""
Local cDescPro 	 := ""
Local cAlias   	 := aCabec[01]
Local nPosAtu  	 := aCabec[02]
Local nPCodPro 	 := aScan(aCotacao[nPosAtu][1],{|x| Trim(x[1])=="C8_PRODUTO"})
Local nPQtdSC8 	 := aScan(aCotacao[nPosAtu][1],{|x| Trim(x[1])=="C8_QUANT"  })
Local nPNumSC  	 := aScan(aCotacao[nPosAtu][1],{|x| Trim(x[1])=="C8_NUMSC"  })
Local nPItemSC 	 := aScan(aCotacao[nPosAtu][1],{|x| Trim(x[1])=="C8_ITEMSC" })
Local nPItemGrd	 := aScan(aCotacao[nPosAtu][1],{|x| Trim(x[1])=="C8_ITEMGRD"})
Local nSC8Recno	 := aScan(aCotacao[nPosAtu][1],{|x| Trim(x[1])=="SC8RECNO"  })
Local nPQtdSCE 	 := aScan(aCabec[05],{|x| Trim(x[2])=="CE_QUANT"  })
Local nPFornSCE	 := aScan(aCabec[05],{|x| Trim(x[2])=="CE_FORNECE"})
Local nPLojaSCE	 := aScan(aCabec[05],{|x| Trim(x[2])=="CE_LOJA"   })
Local nPPropSCE	 := aScan(aCabec[05],{|x| Trim(x[2])=="CE_NUMPRO" })
Local nPItemSCE	 := aScan(aCabec[05],{|x| Trim(x[2])=="CE_ITEMCOT"})
Local nPDataSCE	 := aScan(aCabec[05],{|x| Trim(x[2])=="CE_ENTREGA"})
Local nLinha   	 := (cAlias)->(RecNo())
Local nSaldo   	 := 0
Local nX       	 := 0
Local nY       	 := 0
Local nG       	 := 0
Local nScan    	 := 0
Local lRet	   	 := .T.
Local aRet160Mar := {}    
Local aRet160Mrk := {}
Local nPlanOK    := aScan(aCpoSC8,"PLN_OK")
Local nPlanTotal := aScan(aCpoSC8,"PLN_TOTAL")
//Local nPlanFlag  := aScan(aCpoSC8,"PLN_FLAG")
Local lMarca     := .T.
Local lMt160P    := .T.
Local cItemPE	 := ""

If lRet
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//� Calcula a quantidade selecionada ate o momento                         �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	For nX := 1 To Len(aCols)
		nSaldo += aCols[nX][nPQtdSCE]
	Next nX

	nSaldo := aCotacao[nPosAtu][1][nPQtdSC8][2] - nSaldo

   //	If ( nPlanFlag > 0 .And. aPlanilha[nPosAtu][nLinha][nPlanFlag] == 1 )
	 //	nSaldo := 0
	//EndIf	
	
	If ( nPlanTotal > 0 .And. aPlanilha[nPosAtu][nLinha][nPlanTotal] == 0 )
		Help(" ",1,"A160ATU")
		nSaldo := 0
	EndIf
	
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//� Verifica se a SC esta vinculada a um Edital              �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁 
	If (SC1->C1_QUJE>0 .And. !Empty(SC1->C1_CODED) )
		Aviso("",""+SC1->C1_NUM+""+Alltrim(SC1->C1_CODED)+"",{"Ok"})
		nSaldo := 0
	EndIf

	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//� Verifica se um novo fornecedor pode ser escolhido e atualiza os dados  �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	If (cAlias)->(IsMark("PLN_OK",ThisMark(),ThisInv()))

		If ( nSaldo == 0 )
			RecLock(cAlias)
			(cAlias)->PLN_OK := ""
			MsUnLock()
			
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//� Verifica se existe algum fornecedor marcado  �
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			If aScan(aPlanilha[nPosAtu],{|x| x[nPlanOK] == ThisMark()}) == 0
				lMarca:=.F.
			EndIf
		Else
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
			//� Se vencedor e o Produto for de Grade alimenta a Quantidade do item de Grade com a quantidade do SC8.�
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
			nScan := aScan(aCotaGrade, {|z| z[1] + z[2] + z[3] + z[4] == ;
			aCols[nLinha][nPFornSCE] + aCols[nLinha][nPLojaSCE] + aCols[nLinha][nPPropSCE] + aCols[nLinha][nPItemSCE] })
			
			If Len(aCotaGrade[nScan][6]) > 0

				For nG := 1 To Len(aCotaGrade[nScan][6])
					aCotaGrade[nScan][6][nG][2] := aCotaGrade[nScan][6][nG][6]
					aCotaGrade[nScan][6][nG][3] := aCols[nLinha][nPDataSCE]
				Next nG

				aCols[nLinha][nPQtdSCE] := aCotacao[nPosAtu][1][nPQtdSC8][2]

				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
				//矨pos marcar um Vencedor e preencher os itens da grade com a quantidade original do SC8, esta rotina  �
				//硓era as quantidades da grade das propostas dos demais fornecedores da cotacao deste produto.         �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
				For nX := 1 To Len(aCotaGrade)
					If Len(aCotaGrade[nX][6]) > 0 .And. nX <> nScan .And. aCotaGrade[nX][4] == aCotaGrade[nScan][4]
						For nY:= 1 to Len(aCotaGrade[nX][6])
							aCotaGrade[nX, 6, nY, 2] := 0
						Next nY
					EndIf
				Next nX
	
				For nX := 1 To Len(aCols)
					If nX <> nLinha
						aCols[nX][nPQtdSCE]:= 0
               		EndIf 
				Next nX
			
   			Else
            	aCols[nLinha][nPQtdSCE] += nSaldo
			EndIf
			
			nSaldo := 0

		EndIf

	Else

		nSaldo += aCols[nLinha][nPQtdSCE]
		aCols[nLinha][nPQtdSCE] := 0
		
		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
		//� Se nao for o vencedor e o Produto for de Grade zera a Quantidade do item de Grade.                  �
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
		nScan := aScan(aCotaGrade, {|z| z[1] + z[2] + z[3] + z[4] == ;
		aCols[nLinha][nPFornSCE] + aCols[nLinha][nPLojaSCE] + aCols[nLinha][nPPropSCE] + aCols[nLinha][nPItemSCE] })
		
		If Len(aCotaGrade[nScan][6]) > 0
			For nG := 1 To Len(aCotaGrade[nScan][6])
				aCotaGrade[nScan][6][nG][2] := 0
			Next nG
		EndIf
		
	EndIf

	If (nPlanOK > 0)
		aPlanilha[nPosAtu][nLinha][nPlanOK] := (cAlias)->PLN_OK
	EndIf						
	
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//� Atualiza os dados do cabecalho da analise da cotacao                   �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	dbSelectArea("SC1")
	dbSetOrder(1)
	MsSeek(xFilial("SC1")+aCotacao[nPosAtu][1][nPNumSC][2]+aCotacao[nPosAtu][1][nPItemSC][2])
	
	cCodPro  := SC1->C1_PRODUTO
	cDescPro := SC1->C1_DESCRI
	
	If lGrade .And. !Empty(aCotacao[nPosAtu][1][nPItemGrd][2])
		If (lReferencia := MatGrdPrRf(@cCodPro,.T.))
			cCodPro  := RetCodProdFam(SC1->C1_PRODUTO)
			cDescPro := DescPrRF(cCodPro)
		Endif
	Endif

	aCabec[03,2,2] := cCodPro	//Codigo do Produto
	aCabec[03,2,1] :Refresh()
	
	aCabec[03,3,1]:SetText( Transform( cDescPro, PesqPict("SC8","C8_DESCRI",30) ) ) //Descricao do Produto
	oScroll:Reset()
	
	aCabec[03,5,2] := aCotacao[nPosAtu][1][nPQtdSC8][2] //Quantidade
	aCabec[03,5,1] :Refresh()
	
	aCabec[03,6,1] :cCaption := StrZero(nPosAtu,3)+"/"+StrZero(Len(aPlanilha),3) //Ordem
	aCabec[03,6,1] :Refresh()
	
	aCabec[03,8,2] := nSaldo //Saldo
	aCabec[03,8,1] :Refresh()
	
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//矼onta a Grade para o Produto Analisado.                         �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	A160ColsGrade(aCabec[03,2,2], .T.)
	
EndIf 

If !lMarca
	Aviso("Este fornecedor n鉶 pode ser selecionado, pois n鉶 atende aos crit閞ios de avalia玢o solicitados atrav閟 dos par鈓etros da rotina (F12).",;
	"Este fornecedor n鉶 pode ser selecionado, pois n鉶 atende aos crit閞ios de avalia玢o solicitados atrav閟 dos par鈓etros da rotina (F12).",{""})
Else
	If SuperGetMV("MV_PCOINTE",.F.,"2")=="1"
		//Variaveis para analise de orcamento
		SC8->(MsGoTo(aCotacao[nPosAtu][nLinha][nSC8Recno][2]))
		SC1->(DbSetOrder(1))
		SC1->(MsSeek(xFilial("SC1")+aCotacao[nPosAtu][nLinha][nPNumSC][2]+aCotacao[nPosAtu][nLinha][nPItemSC][2]))
		
		If !PcoVldLan('000052','02',,,Empty((cAlias)->PLN_OK)) .And. lMt160P 
			//Forca a liberacao de todos os lancamentos de bloqueio, pois cada item � uma liberacao exclusiva
			PcoFreeBlq('000052')
			RecLock(cAlias)
				(cAlias)->PLN_OK := ""
			(cAlias)->(MsUnLock())
			
			//Atualizo a planilha para que, caso tenha havido bloqueio, a planilha n鉶 contenha os registros marcados
			//Isso evitar� que ao ser pressionado o bot鉶 "Pr髕imo" a MarkBrowse seja "ticada" incorretamente
			If ValType(nPlanOk) == "N" .And. nPlanOk > 0
				aPlanilha[nPosAtu][nLinha][nPlanOK] := (cAlias)->PLN_OK							
			EndIf
		Endif
		
		If !(cAlias)->(IsMark("PLN_OK",ThisMark(),ThisInv()))
			nSaldo += aCols[nLinha][nPQtdSCE]
			aCols[nLinha][nPQtdSCE] := 0
			
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
			//� Se nao for o vencedor e o Produto for de Grade zera a Quantidade do item de Grade.                  �
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
			nScan := aScan(aCotaGrade, {|z| z[1] + z[2] + z[3] + z[4] == ;
			aCols[nLinha][nPFornSCE] + aCols[nLinha][nPLojaSCE] + aCols[nLinha][nPPropSCE] + aCols[nLinha][nPItemSCE] })
			
			If Len(aCotaGrade[nScan][6]) > 0
				For nG := 1 To Len(aCotaGrade[nScan][6])
					aCotaGrade[nScan][6][nG][2] := 0
				Next nG
			EndIf		
		EndIf

		aCabec[03,2,2] := cCodPro	//Codigo do Produto
		aCabec[03,2,1] :Refresh()
		
		aCabec[03,3,1]:SetText( Transform( cDescPro, PesqPict("SC8","C8_DESCRI",30) ) ) //Descricao do Produto
		oScroll:Reset()
		
		aCabec[03,5,2] := aCotacao[nPosAtu][1][nPQtdSC8][2] //Quantidade
		aCabec[03,5,1] :Refresh()
		
		aCabec[03,6,1] :cCaption := StrZero(nPosAtu,3)+"/"+StrZero(Len(aPlanilha),3) //Ordem
		aCabec[03,6,1] :Refresh()
		
		aCabec[03,8,2] := nSaldo //Saldo
		aCabec[03,8,1] :Refresh()
		
	Endif
EndIf

RestArea(aArea)

Return(.T.) 

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪目北
北矲un噭o    矨160UltFor� Autor 矨lexandre Inacio Lemes � Data �30/05/2007 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪拇北
北矰escricao 矪usca os 4 ultimos Fornecimentos do produto informado e      潮�
北�          砤tualiza o LixtBox do Folder 4 - Historico do Produto        潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砅arametros矱xpC1: Produto a ser pesquisado                              潮�
北�          矱xpA1: Array contendo todos os Objetos da Analise            潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
/*/
User Function A160UltFor(cProduto,aCabec)

If cProduto == Nil
   cProduto := ""
EndIf   
   
aUltForn := MaUltForn(cProduto)
aCabec[11]:CARGO := cProduto
aCabec[11]:SetArray(aUltForn)
aCabec[11]:bLine := {|| aCabec[11]:aArray[aCabec[11]:nAt] }
aCabec[11]:Refresh()

Return(.T.)



/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪目北
北矲un噭o    矼aUltForn � Autor � Eduardo Riera         � Data �27.07.2000 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪拇北
北�          矨valia os ultimos fornecimentos de materiais ( entrada )     潮�
北�          �                                                             潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砈intaxe   矱xpA1 := MaUltForn(ExpC1,ExpA2,ExpA3,ExpN1,ExpL1)			   潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砅arametros矱xpC1: Codigo do Produto                                     潮�
北�          矱xpA2: Array de retorno dos titulos dos campos definidos em  潮�
北�          �       ExpA3.                                                潮�
北�          矱xpA3: Array com a estrutura dos campos a serem retornados   潮�
北�          �       [1] Nome do Campo                                     潮�
北�          �       [2] Tipo do campo                                     潮�
北�          �       [3] Tamanho do campo                                  潮�
北�          �       [4] Numero de decimais do campo                       潮�
北�          �       * Somente do SD1                                      潮�
北�          矱xpN1: Quantidade de ultimos fornecimentos (Default 4)       潮�
北�          矱xpL1: Efetua a conversao para a picture contida no diciona- 潮�
北�          �       rio de dados.                                         潮�
北�          �       * DEFAULT .T.                                         潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砇etorno   矱xpA1: Array contendo os ultimos fornecimentos com os campos 潮�
北�          �       solicitados no parametro ExpA2.                       潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北矰escri噭o 矱sta rotina tem como objetivo avaliar as ultimas <ExpN1>     潮�
北�          砮ntregas do produto <ExpC1> retornando os campos ExpA3.      潮�
北�          �                                                             潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砋so       � Materiais                                                   潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
/*/
User Function MaUltForn(cProduto,aTitles,aCampos,nQtUltFor,lPicture)

Local aArea    := GetArea()
Local aAreaSD1 := SD1->(GetArea())
Local aAreaSX3 := SX3->(GetArea())
Local aUltFor  := {}
Local cAliasSD1:= ""
Local nX       := 0
Local nY	      := 0                        
#IFDEF TOP
	Local cQuery := ""
#ENDIF
DEFAULT aTitles     := {}
DEFAULT aCampos 	:= {}
DEFAULT nQtUltFor	:= 4
DEFAULT lPicture    := .T.
cAliasSD1:= "SD1"
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Inicializa a estrutura default da rotina                     �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
If ( Empty(aCampos) )
	dbSelectArea("SX3")
	dbSetOrder(2)
	MsSeek("D1_EMISSAO")
	aadd(aCampos,{Trim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	MsSeek("D1_QUANT")
	aadd(aCampos,{Trim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	MsSeek("D1_VUNIT")
	aadd(aCampos,{Trim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	MsSeek("D1_TOTAL")
	aadd(aCampos,{Trim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	If cPaisLoc == "BRA"
		MsSeek("D1_VALIPI")
		aadd(aCampos,{Trim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	Endif
	MsSeek("D1_CUSTO")
	aadd(aCampos,{Trim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	MsSeek("D1_FORNECE")
	aadd(aCampos,{Trim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	MsSeek("D1_LOJA")
	aadd(aCampos,{Trim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	dbSelectArea("SX3")
	dbSetOrder(1)
EndIf
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Avalia os ultimos fornecimentos do material                  �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
#IFDEF TOP
	If ( TcSrvType()<>"AS/400" )
		cAliasSD1 := "MAULTFOR"
		For nX := 1 To Len(aCampos)
			cQuery += ","+aCampos[nX][1]
		Next nX
		cQuery := "SELECT "+SubStr(cQuery,2)+" "
		cQuery += "FROM "+RetSqlName("SD1")+" SD1 "
		cQuery += "WHERE SD1.D1_FILIAL='"+xFilial("SD1")+"' AND "
		cQuery += "SD1.D1_COD='"+cProduto+"' AND "
		cQuery += "SD1.D1_TIPO='N' AND "
		cQuery += "SD1.D_E_L_E_T_=' ' "
		cQuery += "ORDER BY SD1.R_E_C_N_O_ DESC "
		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSD1,.T.,.T.)
		For nX := 1 To Len(aCampos)
			If ( aCampos[nX][2]<>"C" )
				TcSetField(cAliasSD1,aCampos[nX,1],aCampos[nX,2],aCampos[nX,3],aCampos[nX,4])
			EndIf
		Next nX

		SX3->(dbSetOrder(2))
		SX3->(MsSeek("A2_NOME"))
		aadd(aCampos,{Trim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		SX3->(dbSetOrder(1))
		
		While ( !Eof() )
			aadd(aUltFor,Array(Len(aCampos)))
			nY++
			For nX := 1 To Len(aCampos)
				aUltFor[nY][nX] := FieldGet(FieldPos(aCampos[nX][1]))
				aUltFor[nY][Len(aCampos)] := IIF(SA2->(MsSeek(xFilial("SA2")+(cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA)),SA2->A2_NOME,"")
			Next nX
			If ( Len(aUltFor)>=nQtUltFor )
				Exit
			EndIf			
			dbSelectArea(cAliasSD1)
			dbSkip()
		EndDo	
		dbSelectArea(cAliasSD1)
		dbCloseArea()
		dbSelectArea("SD1")
	Else
#ENDIF
	SX3->(dbSetOrder(2))
	SX3->(MsSeek("A2_NOME"))
	aadd(aCampos,{Trim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	SX3->(dbSetOrder(1))
	
	dbSelectArea("SD1")
	dbSetOrder(5)
	MsSeek(xFilial("SD1")+cProduto,.T.)
	While ( !Eof() .And. SD1->D1_FILIAL == xFilial("SD1") .And.;
			SD1->D1_COD == cProduto )			
		If ( SD1->D1_TIPO == "N" )
			If ( Len(aUltFor)<nQtUltFor )
				aadd(aUltFor,Array(Len(aCampos)))
				nY++
			Else
				For nY := 1 To nQtUltFor-1
					aUltFor[nY] := aClone(aUltFor[nY+1])
				Next nY
				nY := nQtUltFor
			EndIf
			For nX := 1 To Len(aCampos)
				aUltFor[nY][nX] := FieldGet(FieldPos(aCampos[nX][1]))
				aUltFor[nY][Len(aCampos)] := IIF(SA2->(MsSeek(xFilial("SA2")+(cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA)),SA2->A2_NOME,"")
			Next nX
		EndIf
		dbSelectArea("SD1")
		dbSkip()			
	EndDo
	#IFDEF TOP
	EndIf
	#ENDIF
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Obtem os titulos com base no dicionario de dados             �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
If ( lPicture )
	If ( Len(aUltFor) == 0 )
		aadd(aUltFor,{})
		For nX := 1 To Len(aCampos)
			aadd(aUltFor[1],"")
		Next nX
	EndIf
	dbSelectArea("SX3")
	dbSetOrder(2)
	For nX := 1 To Len(aCampos)
		MsSeek(Trim(aCampos[nX][1]))
		aadd(aTitles,X3Titulo())
		For nY := 1 To Len(aUltFor)
			aUltFor[nY][nX] := TransForm(aUltFor[nY][nX],SX3->X3_PICTURE)
		Next nY
	Next nX
EndIf
RestArea(aAreaSX3)
RestArea(aAreaSD1)
RestArea(aArea)
Return(aUltFor) 

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪目北
北矲un噭o    矨160FeOdlg矨utor  砃ereu Humberto Junior  � Data �18/09/2006 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪拇北
北矰escri噭o 矱sta rotina verifica se todos os itens foram analisados quan-潮�
北�          砫o a analise for produto a produto.                          潮�
北�          砎erifica se todos os itens foram analisados - Cot. p/ Produto潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砅arametros砃enhum                                                       潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砋so       � Materiais                                                   潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
/*/
User Function A160FeOdlg(lProceCot,nOpcA,l160Visual,aCabec,aCotacao,aAuditoria)

Local nPosAtu := aCabec[02]
Local nPQtdSC8:= aScan(aCotacao[1][1],{|x| Trim(x[1])=="C8_QUANT"})
Local nPGrdSC8:= aScan(aCotacao[1][1],{|x| Trim(x[1])=="C8_GRADE"})
Local nPProSCE:= aScan(aCabec[05],{|x| Trim(x[2])=="CE_NUMPRO"})
Local nPForSCE:= aScan(aCabec[05],{|x| Trim(x[2])=="CE_FORNECE"})
Local nPLojSCE:= aScan(aCabec[05],{|x| Trim(x[2])=="CE_LOJA"})
Local nPQtdSCE:= aScan(aCabec[05],{|x| Trim(x[2])=="CE_QUANT"})
Local nPMotSCE:= aScan(aCabec[05],{|x| Trim(x[2])=="CE_MOTIVO"})
Local nSaldo  := 0
Local nX      := 0
Local nY      := 0
Local lRet    := .T. 
Local lVldQtd := GetNewPar("MV_DIFQTDC","N") == "N" .And. If(Type('lIsACC')#"L",.T.,!lIsACC)

If !l160Visual .And. !lProceCot
	If nOpcA == 1 
		For nX:= 1 To Len(aProds)
			If Empty(aProds[nx][3])
				nOpcA:= 0
				lRet := .F.
				Aviso("A cotacao so podera ser confirmada quando todos os itens forem analisados !","A cotacao so podera ser confirmada quando todos os itens forem analisados !",;
				{"A cotacao so podera ser confirmada quando todos os itens forem analisados !"}) //"A cotacao so podera ser confirmada quando todos os itens forem analisados !"
				Exit
			Endif
		Next
	Endif	
Endif

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Executa a validacao do Saldo a Distribuir da pagina atual do Folder    �
//� Auditoria. O Par.MV_DIFQTDC usado para permitir que a analise gere PCs �
//� mesmo que exista saldo a distribuir so tera efeito com produtos que nao�
//� usem grade de produto, caso contrario so proseguira a analise quando   �
//� nao existir mais saldo a distribuir para os produtos de grade.         �
//� Obs:O Help e exibido previamente na Funcao Ma160Page pelo codeBlock    �
//� a validacao aqui impede que o usuario prosiga caso confirme a Analise. �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
If !l160Visual .And. nPosAtu <> 0 
	For nX := 1 To Len(aCols)
		nSaldo += aCols[nX][nPQtdSCE]
	Next nX
	If lVldQtd .Or. aCotacao[nPosAtu][1][nPGrdSC8][2] == "S"
		If ( nSaldo <> aCotacao[nPosAtu][1][nPQtdSC8][2] .And. nSaldo > 0 )
			nOpcA:= 0
			lRet := .F.
		EndIf
	Else
		If ( nSaldo > aCotacao[nPosAtu][1][nPQtdSC8][2] .And. nSaldo > 0 )
			nOpcA:= 0
			lRet := .F.
		EndIf
	Endif	
EndIf  

If GetNewPar("MV_MOTIVOK",.F.) .And. !l160Visual .And. lRet // "Tratamento para obrigatoriedade do preenchimento do Campo MOTIVO do Folder Auditoria da proposta "
    For nX :=1 To Len(aAuditoria)
    	For nY := 1 To Len(aAuditoria[nX])
    	    If aAuditoria[nX][nY][nPQtdSCE] > 0 .And. Empty(aAuditoria[nX][nY][nPMotSCE])			
			   //	Aviso("A160MOTIVO", STR0075 + aAuditoria[nX][nY][nPProSCE] + " " + STR0076 + aAuditoria[nX][nY][nPForSCE]+" "+aAuditoria[nX][nY][nPLojSCE],{STR0028})     
				nOpcA:= 0
		 			lRet := .F.
				Exit
            EndIf
        Next nY
        If !lRet
           Exit
        EndIf                     
    Next nX
EndIf

Return(lRet)

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪穆哪哪哪穆哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噮o    � A160Audit 矨utor  矨lexandre Inacio Lemes矰ata  �04/06/2007潮�
北媚哪哪哪哪呐哪哪哪哪哪牧哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噮o � A funcao e utilizada para recompor o array aAuditoria de   潮�
北�          � forma compativel a gravacao da funcao MaAvalCot da Comxfun.潮�
北�          � Na analise o Array sofreu aglutinacao para uso do recurso  潮�
北�          � de grade de produtos.                                      潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros� ExpA1: Array com todos os elementos da Analise             潮�
北�          � ExpA2: Array contendo dados da auditoria usada na Analise  潮�
北�          � ExpA3: Array contendo todos os itens da cotacao original   潮�
北�          � ExpA4: Array contendo todos elementos da Grade calculada.  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砇etorno   � ExpA1: Array aAudtoria compativel a gravacao da MaAvalCot  潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
/*/
User Function A160Audit(aCabec,aAuditoria,aSC8,aCotagrade)

Local aNewAudit := {}
Local nPosRecn  := aScan(aSC8[1][1],{|x| Trim(x[1])=="SC8RECNO"})
Local nPosProp  := aScan(aSC8[1][1],{|x| Trim(x[1])=="C8_NUMPRO"})
Local nPosForn  := aScan(aSC8[1][1],{|x| Trim(x[1])=="C8_FORNECE"})
Local nPosLoja  := aScan(aSC8[1][1],{|x| Trim(x[1])=="C8_LOJA"})
Local nPosItCt  := aScan(aSC8[1][1],{|x| Trim(x[1])=="C8_ITEM"}) 
Local nPosProd  := aScan(aSC8[1][1],{|x| Trim(x[1])=="C8_PRODUTO"}) 
Local nPosNCot  := aScan(aSC8[1][1],{|x| Trim(x[1])=="C8_NUM"}) 
Local nPosIGrd  := aScan(aSC8[1][1],{|x| Trim(x[1])=="C8_ITEMGRD"}) 
Local nPPropSCE := aScan(aCabec[05],{|x| Trim(x[2])=="CE_NUMPRO"}) 
Local nPFornSCE := aScan(aCabec[05],{|x| Trim(x[2])=="CE_FORNECE"}) 
Local nPLojaSCE := aScan(aCabec[05],{|x| Trim(x[2])=="CE_LOJA"})  
Local nPICotSCE := aScan(aCabec[05],{|x| Trim(x[2])=="CE_ITEMCOT"}) 
Local nPQtdeSCE := aScan(aCabec[05],{|x| Trim(x[2])=="CE_QUANT"}) 
Local nPMotiSCE := aScan(aCabec[05],{|x| Trim(x[2])=="CE_MOTIVO"}) 
Local nPEntrSCE := aScan(aCabec[05],{|x| Trim(x[2])=="CE_ENTREGA"}) 

Local nProdGrd  := 0
Local nScan     := 0
Local nA        := 0
Local nG        := 0
Local nX		:= 0
Local nY 		:= 0
Local nZ        := 0

For nX := 1 to Len(aSC8)
	
	aadd(aNewAudit,{})
	
	For nY := 1 to Len(aSC8[nX])
		
		aadd(aNewAudit[nX],Array(Len(aCabec[05])+1))
		
		For nZ := 1 To Len(aCabec[05])
			
			Do Case
				
				Case IsHeadRec(aCabec[05][nZ][2])
					aNewAudit[nX][Len(aNewAudit[nX])][nZ] := aSC8[nX][nY][nPosRecn][2]
				Case IsHeadAlias(aCabec[05][nZ][2])
					aNewAudit[nX][Len(aNewAudit[nX])][nZ] := "SC8"
				Case aCabec[05][nZ][2]=="CE_NUMPRO"
					aNewAudit[nX][Len(aNewAudit[nX])][nZ] := aSC8[nX][nY][nPosProp][2]
				Case aCabec[05][nZ][2]=="CE_FORNECE"
					aNewAudit[nX][Len(aNewAudit[nX])][nZ] := aSC8[nX][nY][nPosForn][2]
				Case aCabec[05][nZ][2]=="CE_LOJA"
					aNewAudit[nX][Len(aNewAudit[nX])][nZ] := aSC8[nX][nY][nPosLoja][2]
				Case  aCabec[05][nZ][2]=="CE_ITEMCOT"
					aNewAudit[nX][Len(aNewAudit[nX])][nZ] := aSC8[nX][nY][nPosItCt][2]
				Case  aCabec[05][nZ][2]=="CE_NUMCOT"
					aNewAudit[nX][Len(aNewAudit[nX])][nZ] := aSC8[nX][nY][nPosNCot][2]
				Case  aCabec[05][nZ][2]=="CE_ITEMGRD"
					aNewAudit[nX][Len(aNewAudit[nX])][nZ] := aSC8[nX][nY][nPosIGrd][2]
				Case  aCabec[05][nZ][2]=="CE_QUANT"
					//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
					//矱m caso de produto de grade obtem a quantidade do item do Array aCotaGrade,se nao,obtem do aAuditoria�
					//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
					nScan := aScan(aCotaGrade, {|z| z[1] + z[2] + z[3] + z[4] == ;
					aSC8[nX][nY][nPosForn][2] + aSC8[nX][nY][nPosLoja][2] + aSC8[nX][nY][nPosProp][2] + aSC8[nX][nY][nPosItCt][2] })
					If Len(aCotaGrade[nScan][6]) > 0
						nProdGrd := aScan(aCotaGrade[nScan][6], {|z| z[1] == aSC8[nX][nY][nPosProd][2]})
						aNewAudit[nX][Len(aNewAudit[nX])][nZ] := aCotaGrade[nScan][6][nProdGrd][2]
					Else
						For nA := 1 To Len(aAuditoria)
							nScan := aScan(aAuditoria[nA], {|z| z[nPPropSCE] + z[nPFornSCE] + z[nPLojaSCE] + z[nPICotSCE] == ;
							aSC8[nX][nY][nPosProp][2] + aSC8[nX][nY][nPosForn][2] + aSC8[nX][nY][nPosLoja][2] + aSC8[nX][nY][nPosItCt][2] })
							If nScan > 0
								Exit
							EndIf
						Next nA
						aNewAudit[nX][Len(aNewAudit[nX])][nZ] := aAuditoria[nA][nScan][nPQtdeSCE]
					EndIf
				Case  aCabec[05][nZ][2]=="CE_ENTREGA"
					//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
					//矱m caso de produto de grade obtem a data Entrega do Array aCotaGrade,se nao,obtem do aAuditoria      �
					//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
					nScan := aScan(aCotaGrade, {|z| z[1] + z[2] + z[3] + z[4] == ;
					aSC8[nX][nY][nPosForn][2] + aSC8[nX][nY][nPosLoja][2] + aSC8[nX][nY][nPosProp][2] + aSC8[nX][nY][nPosItCt][2]})
					If Len(aCotaGrade[nScan][6]) > 0
						nProdGrd := aScan(aCotaGrade[nScan][6], {|z| z[1] == aSC8[nX][nY][nPosProd][2]})
						aNewAudit[nX][Len(aNewAudit[nX])][nZ] := aCotaGrade[nScan][6][nProdGrd][3]
					Else
						For nA := 1 To Len(aAuditoria)
							nScan := aScan(aAuditoria[nA], {|z| z[nPPropSCE] + z[nPFornSCE] + z[nPLojaSCE] + z[nPICotSCE] == ;
							aSC8[nX][nY][nPosProp][2] + aSC8[nX][nY][nPosForn][2] + aSC8[nX][nY][nPosLoja][2] + aSC8[nX][nY][nPosItCt][2] })
							If nScan > 0
								Exit
							EndIf
						Next nA
						aNewAudit[nX][Len(aNewAudit[nX])][nZ] := aAuditoria[nA][nScan][nPEntrSCE]
					EndIf
				Case  aCabec[05][nZ][2]=="CE_MOTIVO"
					//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
					//砄 Motivo da Analise sempre sera obtido do array aAuditoria aglutinado para compor o novo aAuditoria. �
					//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
					For nA := 1 To Len(aAuditoria)
						nScan := aScan(aAuditoria[nA], {|z| z[nPPropSCE] + z[nPFornSCE] + z[nPLojaSCE] + z[nPICotSCE] == ;
						aSC8[nX][nY][nPosProp][2] + aSC8[nX][nY][nPosForn][2] + aSC8[nX][nY][nPosLoja][2] + aSC8[nX][nY][nPosItCt][2] })
						If nScan > 0
							Exit
						EndIf
					Next nA
					aNewAudit[nX][Len(aNewAudit[nX])][nZ] := aAuditoria[nA][nScan][nPMotiSCE]
				OtherWise
					nScan := 0
					//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
					//矷dentifica o campo especifico no array original da auditoria �
					//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
					For nA := 1 To Len(aAuditoria)
						nScan := aScan(aAuditoria[nA], {|z| z[nPPropSCE] + z[nPFornSCE] + z[nPLojaSCE] + z[nPICotSCE] == ;
						aSC8[nX][nY][nPosProp][2] + aSC8[nX][nY][nPosForn][2] + aSC8[nX][nY][nPosLoja][2] + aSC8[nX][nY][nPosItCt][2] })
						If nScan > 0
							Exit
						EndIf
					Next nA
					If nScan > 0
						aNewAudit[nX][Len(aNewAudit[nX])][nZ] := aAuditoria[nX][nScan][nZ]
					Else
						aNewAudit[nX][Len(aNewAudit[nX])][nZ] := CriaVar(aCabec[CAB_HFLD2][nZ][2],.T.)
					EndIF
			EndCase
			
		Next nZ
		
		aNewAudit[nX][Len(aNewAudit[nX])][ Len(aCabec[05])+1] := .F.
		
	Next nY
	
Next nX

Return(aNewAudit)

/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪目北
北矲un噭o    矼aAvalCOT � Autor � Eduardo Riera         � Data �27.07.2000 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪拇北
北�          砇otina de avaliacao dos eventos do processo de cotacao       潮�
北�          �                                                             潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砈intaxe   矼aAvalCOT(ExpC1,ExpN1,ExpA1,ExpA2,ExpA3,ExpL1,ExpL2,ExpB1)   潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砅arametros矱xpC1:*Alias da tabela de cotacao                            潮�
北�          矱xpN1:*Codigo do Evento                                      潮�
北�          �       [01] Geracao de uma cotacao                           潮�
北�          �       [02] Atualizacao dos precos de uma cotacao            潮�
北�          �       [03] Cancelamento de uma cotacao                      潮�
北�          �       [04] Analise de uma cotacao                           潮�
北�          矱xpA1: Array com as cotacoes(SC8)                            潮�
北�          �       [x] Array com os produtos/identificadores da cotacao  潮�
北�          �    [x][y] Array com os dados de uma cotacao                 潮�
北�          � [x][y][1] Nome do campo                                     潮�
北�          �       [2] Conteudo do campotaacao                           潮�
北�          矱xpA2: Array no formato aHeader das cotacoes vencedoras      潮�
北�          矱xpA3: Array com os produtos/identificadores das cotacoes    潮�
北�          �       vencedoras(SCE)                                       潮�
北�          �       [x] Array no formato acols das cotacoes vencedoras    潮�
北�          矱xpL1: .T. - Mantem a data da necessidade da cotacao(D)      潮�
北�          �       .F. - Ajusta a data da necessidade para a Entrega     潮�
北�          矱xpL2: .T. - Indica que eh o ultimo item da cotacao a ser Av.潮�
北�          矱xpB1: Codeblock de contabilizacao  On-Line.                 潮�
北�          矱xpC2: Codigo do comprador responsavel vindo do ACC		   潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砇etorno   �.T. 	                                                       潮�
北�          �                                                             潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北矰escri噭o 矱sta rotina tem como objetivo atualizar os eventos vinculados潮�
北�          砤 uma cotacao, como:                                         潮�
北�          矨) Atualizacao das tabelas complementares.                   潮�
北�          矪) Atualizacao das informacoes complementares a cotacao      潮�
北�          矯) Executar o B2B                                            潮�
北�          �                                                             潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砋so       � Materiais                                                   潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
/*/
User Function MaAvalCOT(cAliasSC8,nEvento,aSC8,aHeadSCE,aCOLSSCE,lNecessid,lLast,bCtbOnLine,cCompACC)

Local aArea 	:= GetArea()
Local aAreaSC8  := SC8->(GetArea())
Local aRegSC1   := {}
Local aVencedor := {}
Local aPaginas  := {}
Local aRefImp   := {}
Local aSCMail	:= {}
Local aNroItGrd := {}
Local cNumCot   := ""
Local cProduto  := ""
Local cIdent    := ""
Local cQuery    := ""
Local cCursor   := ""
Local cNumPed   := ""
Local cItemPC   := ""
Local cUsers 	:= ""
Local cCndCot	:= ""
Local cNumContr := ""
Local cItemContr:= ""
Local cFLuxo    := Criavar("C7_FLUXO")
Local lQuery    := .F.
Local lCotSC  	:= SuperGetMV("MV_COTSC")=="S"
Local lTrava	:= .T.
Local nA		:= 0
Local nB		:= 0
Local nX        := 0
Local nY        := 0
Local nZ		:= 0
Local nTotal    := 0
Local nPQtdSCE  := 0
Local nPMotSCE  := 0
Local nPRegSC8  := 0
Local nPForSC8  := 0
Local nPLojSC8  := 0
Local nPCndSC8  := 0
Local nPPrdSC8  := 0
Local nPFilSC8  := 0
Local nScan     := 0
Local nSaveSX8  := GetSX8Len()
Local cGrupo	:= SuperGetMv("MV_PCAPROV")
Local lLiberou	:= .F.
Local lPEGerPC  := ExistBlock("MT160GRPC")
Local cNPed     := ''

DEFAULT aSC8      := {}
DEFAULT aHeadSCE  := {}
DEFAULT aCOLSSCE  := {}
DEFAULT lNecessid := .T.
DEFAULT lLast     := .F.
DEFAULT bCtbOnLine:= {|| .T.}
DEFAULT cCompACC  := ""

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Verifica o grupo de aprovacao do Comprador.                  �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
dbSelectArea("SY1")
dbSetOrder(3)
If dbSeek(xFilial("SY1")+If(Empty(cCompACC),RetCodUsr(),cCompACC))
	cGrupo	:= If(!Empty(Y1_GRAPROV),SY1->Y1_GRAPROV,cGrupo)
EndIf
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Ponto de entrada para alterar o Grupo de Aprovacao.          �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁

Do Case
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//矷mplantacao de uma cotacao                                              �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
Case nEvento == 1
	cNumCot   := (cAliasSC8)->C8_NUM
	cProduto  := (cAliasSC8)->C8_PRODUTO
	cIdent    := (cAliasSC8)->C8_IDENT
	If ( lLast )
		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
		//矼-Message - Verifica o Evento 003 - Solicitacao com cotacao pendente.   �
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
		If MExistMail("003")
			#IFDEF TOP
				If ( TcSrvType()<>"AS/400" )
					cCursor := "MAAVALCOT"
					cQuery := "SELECT C1_NUM,C1_ITEM,C1_DESCRI,C1_USER,C1_SOLICIT,C1_OP "
					cQuery += "FROM "+RetSqlName("SC1")+" SC1 "
					cQuery += "WHERE SC1.C1_FILIAL='"+xFilial("SC1")+"' AND "
					cQuery += "SC1.C1_COTACAO='"+cNumCot+"' AND "
					cQuery += "SC1.C1_PRODUTO='"+cProduto+"' AND "
					cQuery += "SC1.C1_IDENT='"+cIdent+"' AND "
					cQuery += "SC1.D_E_L_E_T_<>'*'"
					cQuery := ChangeQuery(cQuery)
					SC1->(dbCommit())					
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cCursor,.T.,.T.)
					While ( !Eof() )
						aadd(aSCMail,C1_NUM+"/"+C1_ITEM+" "+C1_SOLICIT+" "+C1_DESCRI)
						cUsers += C1_USER+"#"							
						dbSelectArea(cCursor)
						dbSkip()					
					EndDo
					dbSelectArea(cCurSor)
					dbCloseArea()
					dbSelectArea("SC1")					
				Else
			#ENDIF
				dbSelectArea("SC1")
				dbSetOrder(5)
				MsSeek(xFilial("SC1")+cNumCot+cProduto+cIdent)
				While ( !Eof() .And. xFilial("SC1")	== SC1->C1_FILIAL .And.;
						cNumCot		== SC1->C1_COTACAO.And.;
						cProduto == SC1->C1_PRODUTO.And.;
						cIdent == SC1->C1_IDENT )
					aadd(aSCMail,C1_NUM+"/"+C1_ITEM+" "+C1_SOLICIT+" "+C1_DESCRI)
					cUsers += C1_USER+"#"
					dbSelectArea("SC1")
					dbSkip()
				EndDo
				#IFDEF TOP
				EndIf			
				#ENDIF
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
			//矱nvia e-mail do Evento 003                                              �
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
			MEnviaMail("003",{cNumCot,aSCMail},cUsers)
		EndIf
		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
		//砃eogrid - Verifica a existencia da Administracao colaborativa de Pedidos�
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
		If ( NeoEnable("001") )
			NeoEnvCot(cNumCot)
		EndIf
	EndIf
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//矨tualizacao dos precos de uma cotacao                                   �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
Case nEvento == 2
	cNumCot   := (cAliasSC8)->C8_NUM
	cCndCot   := (cAliasSC8)->C8_COND
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//砎erifica a existencia do Evento 004 - Cotacao com analise pendente.     �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	If lLast .And. !Empty(cCndCot)
		MEnviaMail("004",{cNumCot})
	EndIf		
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//矯ancelamento da cotacao                                                 �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
Case nEvento == 3
	cNumCot   := (cAliasSC8)->C8_NUM
	cProduto  := (cAliasSC8)->C8_PRODUTO
	cIdent    := (cAliasSC8)->C8_IDENT
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//砈omente estornar a solicitacao de compra quando esta nao possuir cotacao�
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	dbSelectArea(cAliasSC8)
	dbSetOrder(4)		
	If ( !MsSeek(xFilial("SC8")+cNumCot+cIdent+cProduto) )
		#IFDEF TOP
			If ( TcSrvType()<>"AS/400" )
				cCursor := "MAAVALCOT"
				cQuery := "SELECT R_E_C_N_O_ SC1RECNO "
				cQuery += "FROM "+RetSqlName("SC1")+" SC1 "
				cQuery += "WHERE SC1.C1_FILIAL='"+xFilial("SC1")+"' AND "
				cQuery += "SC1.C1_COTACAO='"+cNumCot+"' AND "
				cQuery += "SC1.C1_PRODUTO='"+cProduto+"' AND "
				cQuery += "SC1.C1_IDENT='"+cIdent+"' AND "
				cQuery += "SC1.D_E_L_E_T_<>'*'"
				cQuery := ChangeQuery(cQuery)
				SC1->(dbCommit())					
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cCursor,.T.,.T.)
				While ( !Eof() )
					aadd(aRegSC1,SC1RECNO)
					dbSelectArea(cCursor)
					dbSkip()					
				EndDo
				dbSelectArea(cCurSor)
				dbCloseArea()
				dbSelectArea("SC1")					
			Else
		#ENDIF
			dbSelectArea("SC1")
			dbSetOrder(5)
			MsSeek(xFilial("SC1")+cNumCot+cProduto+cIdent)
			While ( !Eof() .And. xFilial("SC1")	== SC1->C1_FILIAL .And.;
					cNumCot		== SC1->C1_COTACAO.And.;
					cProduto == SC1->C1_PRODUTO.And.;
					cIdent == SC1->C1_IDENT )
				aadd(aRegSC1,RecNo())
				dbSelectArea("SC1")
				dbSkip()
			EndDo
			#IFDEF TOP
			EndIf			
			#ENDIF			
		For nX := 1 To Len(aRegSC1)
			dbSelectArea("SC1")
			MsGoto(aRegSC1[nX])
			RecLock("SC1",.F.)
			If ( lCotSC .And. SC1->C1_QUJE < SC1->C1_QUANT )
				SC1->C1_COTACAO := ""
			Else
				SC1->C1_COTACAO := Repl("X",Len(SC1->C1_COTACAO))
			EndIf
			
		Next nX
	EndIf
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//矨nalise da cotacao                                                      �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
Case nEvento == 4
	nPQtdSCE  := aScan(aHeadSCE,{|x| Trim(x[2])=="CE_QUANT"})
	nPMotSCE  := aScan(aHeadSCE,{|x| Trim(x[2])=="CE_MOTIVO"})
	nPEntSCE  := aScan(aHeadSCE,{|x| Trim(x[2])=="CE_ENTREGA"})
	nPRegSC8  := aScan(aSC8[1][1],{|x| Trim(x[1])=="SC8RECNO"})
	nPForSC8  := aScan(aSC8[1][1],{|x| Trim(x[1])=="C8_FORNECE"})
	nPLojSC8  := aScan(aSC8[1][1],{|x| Trim(x[1])=="C8_LOJA"})
	nPCndSC8  := aScan(aSC8[1][1],{|x| Trim(x[1])=="C8_COND"})
	nPPrdSC8  := aScan(aSC8[1][1],{|x| Trim(x[1])=="C8_PRODUTO"})
	nPFilSC8  := aScan(aSC8[1][1],{|x| Trim(x[1])=="C8_FILENT"})

	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//砎erifico quais fornecedores possuem cotacoes vencedoras                 �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	For nX := 1 To Len(aColsSCE)
		For nY := 1 To Len(aColsSCE[nX])
			dbSelectArea("SC8")
			MsGoto(aSC8[nX][nY][nPRegSC8][2])
			If ( aColsSCE[nX][nY][nPQtdSCE] > 0 )
				If ( RecLock("SC8") )
					nZ := aScan(aVencedor,{|x| x[1]==aSC8[nX][nY][nPForSC8][2].And.;
						x[2]==aSC8[nX][nY][nPLojSC8][2].And.;
						x[3]==aSC8[nX][nY][nPCndSC8][2].And.;
						x[4]==aSC8[nX][nY][nPFilSC8][2]})
					If ( nZ == 0 )
						aadd(aVencedor,{aSC8[nX][nY][nPForSC8][2],;
							aSC8[nX][nY][nPLojSC8][2],;
							aSC8[nX][nY][nPCndSC8][2],;
							aSC8[nX][nY][nPFilSC8][2]})
					EndIf
				EndIf
			EndIf
		Next nY
	Next nX
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//砎erifica a quais impostos devem ser gravados.                           �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	aRefImp := MaFisRelImp('MT100',{"SC7"})
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//矱fetua a gravacao dos pedidos para cada Vencedor                        �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	For nZ := 1 To Len(aVencedor)
		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
		//砊ravo todos os registros antes de iniciar a gravacao                    �
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
		lTrava := .T.
		For nX := 1 To Len(aColsSCE)
			For nY := 1 To Len(aColsSCE[nX])
				If ( aVencedor[nZ][1]==aSC8[nX][nY][nPForSC8][2].And.;
						aVencedor[nZ][2]==aSC8[nX][nY][nPLojSC8][2].And.;
						aVencedor[nZ][3]==aSC8[nX][nY][nPCndSC8][2].And.;
						aVencedor[nZ][4]==aSC8[nX][nY][nPFilSC8][2] )
					
					dbSelectArea("SC8")
					MsGoto(aSC8[nX][nY][nPRegSC8][2])
					If (!RecLock("SC8") )
						CRI := .F.
						Exit
					EndIf
				EndIf
			Next nY
		Next nX
		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
		//矷nicio o processo de gravacao do Pedido de Compra                       �
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
		If ( lTrava )
		  	cNumPed := U_TPCOM003()            //CriaVar("C7_NUM",.T.)
			While ( GetSX8Len() > nSaveSX8 )
				ConfirmSx8()
			EndDo
			cItemPC   := StrZero(1,Len(SC7->C7_ITEM))
			nTotal    := 0
			If ( Empty(cNumPed) )
				cNumPed := U_TPCOM003()
			EndIf
			For nX := 1 To Len(aColsSCE)
				For nY := 1 To Len(aColsSCE[nX])
					If ( aVencedor[nZ][1]==aSC8[nX][nY][nPForSC8][2].And.;
							aVencedor[nZ][2]==aSC8[nX][nY][nPLojSC8][2].And.;
							aVencedor[nZ][3]==aSC8[nX][nY][nPCndSC8][2].And.;
							aVencedor[nZ][4]==aSC8[nX][nY][nPFilSC8][2].And.;
							aColsSCE[nX][nY][nPQtdSCE]<>0)
						//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
						//矴uarda as paginas que houveram vencedores                               �
						//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
						If ( aScan(aPaginas,nX)==0 )
							aadd(aPaginas,nX)
						EndIf
						dbSelectArea("SB1")
						dbSetOrder(1)
						MsSeek(xFilial("SB1")+aSC8[nX][nY][nPPrdSC8][2])
						dbSelectArea("SC8")
						MsGoto(aSC8[nX][nY][nPRegSC8][2])
						dbSelectArea("SC1")
						dbSetOrder(5)
						MsSeek(xFilial("SC1")+SC8->C8_NUM+SC8->C8_PRODUTO+SC8->C8_IDENT)
						dbSelectArea("SA2")
						dbSetOrder(1)
						MsSeek(xFilial("SA2")+aVencedor[nZ][1]+aVencedor[nZ][2])
						//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
						//矷ncluo o item do Pedido de Compra                                       �
						//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
						RecLock("SC7",.T.)
						dbSelectArea("SC7")
						For nA := 1 to SC7->(FCount())
							nB := SC8->(FieldPos("C8"+SubStr(SC7->(FieldName(nA)),3)))
							If ( nB <> 0 )
								FieldPut(nA,SC8->(FieldGet(nB)))
							EndIf
						Next nA

						//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
						//矯ontrola a numeracao do Item no PC quando for Item de Grade vindo do SC8�
						//砄bservar que o Numero do Item no PC C7_ITEM sera trocado toda vez que na�
						//砿esma grade o C8_PRECO for diferente, ou seja, somente sera aglutinado  �
						//硁a mesma grade (mesmo C7_ITEM) os itens do Grid que possuirem o mesmo   �
						//硃reco para preservar os valores,calculos de impostos e afins.           �
						//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
						If SC8->C8_GRADE == "S"

							cProdRef := SC8->C8_PRODUTO
							lReferencia := MatGrdPrrf(@cProdRef, .T.)
							
							If (nScan := aScan(aNroItGrd, {|x| x[1] + x[2] + x[3] + x[4] + x[5] + x[6] + x[7] + x[8] == ;
								SC8->C8_ITEM + cProdRef + SC8->C8_NUMPRO + SC8->C8_FORNECE + SC8->C8_LOJA + SC8->C8_NUMSC + SC8->C8_ITEMSC + TransForm(SC8->C8_PRECO,PesqPict("SC8","C8_PRECO")) })) == 0

								Aadd(aNroItGrd, { SC8->C8_ITEM , cProdRef , SC8->C8_NUMPRO , SC8->C8_FORNECE , SC8->C8_LOJA ,SC8->C8_NUMSC ,SC8->C8_ITEMSC ,TransForm(SC8->C8_PRECO,PesqPict("SC8","C8_PRECO")) , cItemPc } )
								nScan := Len(aNroItGrd)
								cItemPc	:= Soma1(cItemPc)

							Endif
						Else
							nScan := Nil
						EndIf
												
						SC7->C7_FILIAL  := SC8->C8_FILIAL
						SC7->C7_TIPO    := 1
						SC7->C7_NUM     := cNumPed
						SC7->C7_ITEM    := If(nScan == Nil, cItemPc , aNroItGrd[nScan, 9 ])
						SC7->C7_GRADE   := SC8->C8_GRADE
						SC7->C7_ITEMGRD := SC8->C8_ITEMGRD
						SC7->C7_FORNECE := aVencedor[nZ][1]
						SC7->C7_LOJA    := aVencedor[nZ][2]
						SC7->C7_COND    := aVencedor[nZ][3]
						SC7->C7_OP      := SC1->C1_OP
						SC7->C7_LOCAL   := SC1->C1_LOCAL
						SC7->C7_DESCRI  := Posicione("SC1",1,SC8->C8_FILIAL+SC8->C8_NUMSC+SC8->C8_ITEMSC,"C1_DESCRI")
						SC7->C7_UM      := Posicione("SC1",1,SC8->C8_FILIAL+SC8->C8_NUMSC+SC8->C8_ITEMSC,"C1_UM")
						SC7->C7_FILENT  := SC1->C1_FILENT
						SC7->C7_SEGUM   := SC1->C1_SEGUM
						SC7->C7_QUANT   := aColsSCE[nX][nY][nPQtdSCE]
						SC7->C7_QTDSOL  := 0 //aColsSCE[nX][nY][nPQtdSCE]
						SC7->C7_QTSEGUM := IIf(SB1->B1_CONV==0,SC1->C1_QTSEGUM,ConvUm(aSC8[nX][nY][nPPrdSC8][2],aColsSCE[nX][nY][nPQtdSCE],0,2))
						SC7->C7_PRECO   := SC8->C8_PRECO
						SC7->C7_TOTAL   := NoRound(SC7->C7_QUANT*SC7->C7_PRECO)
						SC7->C7_CONTATO := SC8->C8_CONTATO
						SC7->C7_OBS     := SC8->C8_OBS
						SC7->C7_ZMARCOD := SC8->C8_ZMARCA
						SC7->C7_ZOBSADI := Posicione("SC1",1,SC8->C8_FILIAL+SC8->C8_NUMSC+SC8->C8_ITEMSC,"C1_ZOBSADI")
						SC7->C7_EMISSAO := dDataBase
						SC7->C7_DATPRF  := IIf(lNecessid,aColsSCE[nX][nY][nPentSCE],dDataBase+SC8->C8_PRAZO)
						SC7->C7_CC      := Posicione("SC1",1,SC8->C8_FILIAL+SC8->C8_NUMSC+SC8->C8_ITEMSC,"C1_CC")
						SC7->C7_ITEMCTA := SC1->C1_ITEMCTA
						SC7->C7_CLVL    := SC1->C1_CLVL
						SC7->C7_CONTA   := SC1->C1_CONTA
						SC7->C7_ITEMCTA := SC1->C1_ITEMCTA
						SC7->C7_ORIGEM  := SC1->C1_ORIGEM
						SC7->C7_DESC1   := SC8->C8_DESC1
						SC7->C7_DESC2   := SC8->C8_DESC2
						SC7->C7_DESC3   := SC8->C8_DESC3
						SC7->C7_REAJUST := SC8->C8_REAJUST
						SC7->C7_IPI     := SC8->C8_ALIIPI
						SC7->C7_NUMSC   := SC8->C8_NUMSC
						SC7->C7_ITEMSC  := SC8->C8_ITEMSC
						SC7->C7_NUMCOT  := SC8->C8_NUM
						SC7->C7_FILENT  := SC8->C8_FILENT
						SC7->C7_TPFRETE := SC8->C8_TPFRETE
						SC7->C7_VLDESC  := ((SC7->C7_TOTAL*SC8->C8_VLDESC)/SC8->C8_TOTAL)
						SC7->C7_IPIBRUT := "B"
						SC7->C7_USER    := IIF(Empty(SC8->C8_ZUSER),__cUserID,SC8->C8_ZUSER)
						SC7->C7_VALEMB  := SC8->C8_VALEMB
						SC7->C7_FRETE   := SC8->C8_TOTFRE
						SC7->C7_ZAPLIC  := SC8->C8_ZAPLIC
						SC7->C7_CONAPRO := "B"
						SC7->C7_GRUPCOM := "000005"
						SC7->C7_FLUXO   := cFluxo
					 
						//cNPed := IIF (AT(cNumPed, cNPed ) > 0,Alltrim(cNPed) + Chr(13) + Chr(10),Alltrim(cNPed  +'_'+ cNumPed) + Chr(13) + Chr(10))
						
						IF (AT(cNumPed, cNPed ) == 0 )
						cNPed += Alltrim(cNumPed)+'-'+Posicione("SA2",1,xFilial("SA2")+aVencedor[nZ][1]+aVencedor[nZ][2],"A2_NOME") + Chr(13) + Chr(10) 
						ENDIF
						If SC7->(FieldPos("C7_RATEIO")) > 0
							SC7->C7_RATEIO  := CriaVar('C7_RATEIO',.T.)			
						EndIf
						
						If SC7->(FieldPos("C7_ACCNUM")) > 0 .And. If(Type('lIsACC')#"L",.F.,lIsACC)
							SC7->C7_ACCNUM  := aColsSCE[nX][nY][Len(aColsSCE[nX][nY])-1]
							SC7->C7_ACCITEM := aColsSCE[nX][nY][Len(aColsSCE[nX][nY])]
						//	SC7->C7_USER    := __cUserID//cCompACC
						EndIf
						
						MaFisIni(aVencedor[nZ][1],aVencedor[nZ][2],"F","N","R",aRefImp)						
						
						SC7->C7_APROV   := cGrupo
						IIF(Empty(SC7->C7_USER),Alert("N鉶 gravou usu醨io"),'') 
					   	MsUnLock()
						MaFisIniLoad(1)
						For nA := 1 To Len(aRefImp)
							MaFisLoad(aRefImp[nA][3],FieldGet(FieldPos(aRefImp[nA][2])),1)
						Next nA
						MaFisRecal("",1)
						MaFisEndLoad(1)
						MaFisAlt("IT_ALIQIPI",SC7->C7_IPI,1)
						MaFisAlt("IT_ALIQICM",SC7->C7_PICM,1)
						MaFisWrite(1,"SC7",1)
						MaFisWrite(2,"SC7",1,.F.)
						nTotal += MaFisRet(1,"IT_TOTAL")
						MaFisEnd()
						//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
						//矱ncerro a cotacao vencedora                                             �
						//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
						dbSelectArea("SC8")
						MsGoto(aSC8[nX][nY][nPRegSC8][2])
						SC8->C8_NUMPED := cNumPed
						SC8->C8_ITEMPED:= If(nScan == Nil, cItemPc , aNroItGrd[nScan, 9 ])
						SC8->C8_MOTIVO := aColsSCE[nX][nY][nPMotSCE]
						SC8->C8_DATPRF := IIf(lNecessid,aColsSCE[nX][nY][nPentSCE],dDataBase+SC8->C8_PRAZO)
						SC8->C8_PRAZO  := SC8->C8_DATPRF - dDataBase
						RecLock("SCE",.T.)
						SCE->CE_FILIAL := xFilial("SCE")
						SCE->CE_NUMCOT := SC8->C8_NUM
						SCE->CE_ITEMCOT:= SC8->C8_ITEM
						SCE->CE_NUMPRO := SC8->C8_NUMPRO
						SCE->CE_PRODUTO:= SC8->C8_PRODUTO
						SCE->CE_FORNECE:= SC8->C8_FORNECE
						SCE->CE_LOJA   := SC8->C8_LOJA
						SCE->CE_ITEMGRD:= SC8->C8_ITEMGRD
						For nA := 1 To Len(aHeadSCE)
							//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
							//� Nao grava campos virutais e de controle (walkthru)   �
							//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
							If !(IsHeadRec(Trim(aHeadSCE[nA][2])) .OR. IsHeadAlias(Trim(aHeader[nA][2])) .OR. aHeader[nA][10] == "V")
								FieldPut(FieldPos(aHeadSCE[nA][2]),aCOLSSCE[nX][nY][nA])
							EndIf
						Next nA
						SCE->CE_MOTIVO := aColsSCE[nX][nY][nPMotSCE]
						SCE->CE_ENTREGA:= IIf(lNecessid,aColsSCE[nX][nY][nPentSCE],dDataBase+SC8->C8_PRAZO)							
						If SC8->C8_QTDCTR > 0
							//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
							//� Gravacao do Contrato de Parceria                     �
							//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
							If Empty(cNumContr)
								cNumContr := CriaVar("C3_NUM",.T.)
								cItemContr:= Strzero(1,Len(SC3->C3_ITEM))
								While ( GetSX8Len() > nSaveSX8 )
									ConfirmSx8()
								EndDo				
							EndIf
							RecLock("SC3",.T.)
							dbSelectArea("SC3")
							SC3->C3_FILIAL  := xFilial("SC3")
							SC3->C3_NUM     := cNumContr
							SC3->C3_FORNECE := aVencedor[nZ][1]
							SC3->C3_LOJA    := aVencedor[nZ][2]
							SC3->C3_GRADE   := SC8->C8_GRADE
							SC3->C3_ITEMGRD := SC8->C8_ITEMGRD
							SC3->C3_ITEM    := cItemContr
							SC3->C3_PRODUTO := SC8->C8_PRODUTO
							SC3->C3_QUANT   := SC8->C8_QTDCTR
							SC3->C3_PRECO   := SC8->C8_PRECO
							SC3->C3_TOTAL   := SC3->C3_PRECO*SC3->C3_QUANT
							SC3->C3_DATPRI  := dDataBase
							SC3->C3_DATPRF  := IIf(lNecessid,aColsSCE[nX][nY][nPentSCE],dDataBase+SC8->C8_PRAZO)
							SC3->C3_LOCAL   := SC1->C1_LOCAL
							SC3->C3_COND    := aVencedor[nZ][3]
							SC3->C3_CONTATO := SC8->C8_CONTATO
							SC3->C3_FILENT  := SC8->C8_FILENT
							SC3->C3_EMISSAO := dDatabase
							SC3->C3_REAJUST := SC8->C8_REAJUST
							SC3->C3_TPFRETE := SC8->C8_TPFRETE
							SC3->C3_FRETE   := SC8->C8_TOTFRE
							SC3->C3_OBS     := SC8->C8_ZOBSADI
							If SC3->(FieldPos("C3_AVISTA"))<>0
								SC3->C3_AVISTA := SC8->C8_AVISTA
							EndIf
							If SC3->(FieldPos("C3_TAXAFOR"))<>0
								SC3->C3_TAXAFOR := SC8->C8_TAXAFOR
							EndIf
							MsUnLock()
							SB1->(DBSetOrder(1))
							If SB1->(MsSeek(xFilial("SB1")+SC8->C8_PRODUTO))
								RecLock("SB1",.F.)
								Replace SB1->B1_CONTRAT With "S"
								Replace SB1->B1_PROC    With aVencedor[nZ][1]
								Replace SB1->B1_LOJPROC With aVencedor[nZ][2]
								MsUnLock()
							EndIf
							cItemContr  :=  Soma1(cItemContr,Len(SC3->C3_ITEM))
						EndIf
						//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
						//� Atualizo os acumulados do Pedido de Compra           �
						//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁							
						MaAvalPC("SC7",1,nZ==Len(aVencedor),Nil,Nil,Nil,bCtbOnLine,.F.)

						If nScan == Nil 
  							cItemPc	:= Soma1(cItemPc)
         				EndIf

					EndIf
				Next nY
			Next nX

			lLiberou := U_MaAlcDoc({SC7->C7_NUM,"PC",nTotal,,,SC7->C7_APROV,,SC7->C7_MOEDA,SC7->C7_TXMOEDA,SC7->C7_EMISSAO},dDataBase,1,,,SC7->C7_USER)
			
			//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
			//� Integracao ACC envia aprovacao do pedido            �
			//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�			
			If lLiberou .And. If(FindFunction("WebbConfig"),WebbConfig(.F.),.F.) .And. !Empty(SC7->C7_ACCNUM)
				If IsBlind()
					Webb533(SC7->C7_NUM)
				Else
					MsgRun("Aguarde, comunicando aprova玢o ao portal","Portal ACC",{|| Webb533(SC7->C7_NUM)}) //Aguarde, comunicando aprova玢o ao portal ## Portal ACC
				EndIf
			EndIf
			
			#IFDEF TOP
				If TcSrvType()<>"AS/400"
					SC7->(dbCommit())
					cQuery := "UPDATE "
					cQuery += RetSqlName("SC7")+" "	
					cQuery += "SET C7_CONAPRO = '"+ IIf( !lLiberou .Or. GetNewPar("MV_SIGAGSP","0") == "1" , "B" , "L" ) + "' "
					cQuery += "WHERE C7_FILIAL='"+xFilial("SC7")+"' AND "
					cQuery += "C7_NUM='"+cNumPed+"' AND "
					cQuery += "D_E_L_E_T_=' ' "					
					TcSqlExec(cQuery)
					SC7->(DbGoto(RecNo()))
				Else
			#ENDIF
				dbSelectArea("SC7")
				dbSetOrder(1)
				dbSeek(xFilial()+cNumPed)
				While !Eof() .And. C7_FILIAL+C7_NUM == xFilial("SC7")+cNumPed
					RecLock("SC7",.F.)    // CRISTIANO FERREIRA
					If !lLiberou .Or. GetNewPar("MV_SIGAGSP","0") == "1" //Consiste parametro de integracao do SIGAGSP. GERAR SEMPRE BLOQUEADO  
						SC7->C7_CONAPRO := "B"
					Else
						SC7->C7_CONAPRO := "B"  
					EndIf
					MsUnlock()
					dbSkip()
				EndDo                                                                                 
				#IFDEF TOP
				EndIf
				#ENDIF
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//� Envia e-mail na inclusao do Pedido de Compras.                   �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
				SC7->(MsSeek(xFilial("SC7")+cNumPed))
				MEnviaMail("037",{SC7->C7_NUM,SC7->C7_NUMCOT,SC7->C7_APROV,SC7->C7_CONAPRO,Subs(cUsuario,7,15)})
		EndIf
                                                                                                                            
	Next nZ
	MsgInfo("Ol�"+' '+CUserName+' '+' '+"-"+' '+"Pedidos Gerados"+' '+ Chr(13) + Chr(10) + cNPed, "TOPMIX")
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//砊ratamento das cotacoes perdedoras que foram analisadas                 �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	For nZ := 1 To Len(aPaginas)
		nX := aPaginas[nZ]
		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
		//矷nicio o processo de gravacao do Pedido de Compra                       �
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
		For nY := 1 To Len(aColsSCE[nX])
			dbSelectArea("SC8")
			MsGoto(aSC8[nX][nY][nPRegSC8][2])
			If ( Empty(SC8->C8_NUMPED) )
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//矱ncerro as cotacoes perdedoras                                          �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
				RecLock("SC8")
				SC8->C8_NUMPED := Repl("X",Len(SC8->C8_NUMPED))
				SC8->C8_ITEMPED:= Repl("X",Len(SC8->C8_ITEMPED))
				SC8->C8_MOTIVO := aColsSCE[nX][nY][nPMotSCE]
			EndIf
		Next nY
	Next nZ
EndCase

RestArea(aAreaSC8)
RestArea(aArea)
Return(.T.)

/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噮o    � MaAlcDoc � Autor � Aline Correa do Vale  � Data �07.08.2001潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噮o � Controla a alcada dos documentos (SCS-Saldos/SCR-Bloqueios)潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砈intaxe   � MaAlcDoc(ExpA1,ExpD1,ExpN1,ExpC1,ExpL1)               	  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros� ExpA1 = Array com informacoes do documento                 潮�
北�          �       [1] Numero do documento                              潮�
北�          �       [2] Tipo de Documento                                潮�
北�          �       [3] Valor do Documento                               潮�
北�          �       [4] Codigo do Aprovador                              潮�
北�          �       [5] Codigo do Usuario                                潮�
北�          �       [6] Grupo do Aprovador                               潮�
北�          �       [7] Aprovador Superior                               潮�
北�          �       [8] Moeda do Documento                               潮�
北�          �       [9] Taxa da Moeda                                    潮�
北�          �      [10] Data de Emissao do Documento                     潮�
北�          �      [11] Grupo de Compras                                 潮�
北�          �      [12] Aprovador Original                               潮�
北�          � ExpD1 = Data de referencia para o saldo                    潮�
北�          � ExpN1 = Operacao a ser executada                           潮�
北�          �       1 = Inclusao do documento                            潮�
北�          �       2 = Transferencia para Superior                      潮�
北�          �       3 = Exclusao do documento                            潮�
北�          �       4 = Aprovacao do documento                           潮�
北�          �       5 = Estorno da Aprovacao                             潮�
北�          �       6 = Bloqueio Manual da Aprovacao                     潮�
北�          � ExpC1 = Chave(Alternativa) do SF1 para exclusao SCR        潮�
北�          � ExpL1 = Eliminacao de Residuos                             潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � Generico                                                   潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�
*/
User Function MaAlcDoc(aDocto,dDataRef,nOper,cDocSF1,lResiduo,cPC)

Local cDocto	:= aDocto[1]
Local cTipoDoc	:= aDocto[2]
Local nValDcto	:= aDocto[3]
Local cAprov	:= If(aDocto[4]==Nil,"",aDocto[4])
Local cUsuario	:= If(aDocto[5]==Nil,"",aDocto[5])
Local nMoeDcto	:= If(Len(aDocto)>7,If(aDocto[8]==Nil, 1,aDocto[8]),1)
Local nTxMoeda	:= If(Len(aDocto)>8,If(aDocto[9]==Nil, 0,aDocto[9]),0)
Local cObs      := If(Len(aDocto)>10,If(aDocto[11]==Nil, "",aDocto[11]),"")
Local aArea		:= GetArea()
Local aAreaSCS	:= SCS->(GetArea())
Local aAreaSCR	:= SCR->(GetArea())
Local aRetPe	:= {}
Local nSaldo	:= 0
Local cGrupo	:= If(aDocto[6]==Nil,"",aDocto[6])
Local lFirstNiv:= .T.
Local cAuxNivel:= ""
Local cNextNiv := ""
Local cNivIgual:= ""
Local cStatusAnt:= ""
Local cAprovOri := ""    
Local cUserOri  := ""
Local lAchou	:= .F.
Local nRec		:= 0
Local lRetorno	:= .T.
Local aSaldo	:= {} 
Local aMTALCGRU := {}
Local lDeletou := .F.
Local dDataLib := IIF(dDataRef==Nil,dDataBase,dDataRef) 
Private cGeraSCR := 'S'
DEFAULT dDataRef := dDataBase
DEFAULT cDocSF1 := cDocto
DEFAULT lResiduo := .F.
cDocto := cDocto+Space(Len(SCR->CR_NUM)-Len(cDocto))
cDocSF1:= cDocSF1+Space(Len(SCR->CR_NUM)-Len(cDocSF1)) 

If Empty(cPC)
 Alert("Pedido"+' '+cDocto+' '+ "sem usu醨io gravado, favor entrar em contato com o Cristiano da TI.")
Endif

If lRetorno

	If Empty(cUsuario) .And. (nOper != 1 .And. nOper != 6) //nao e inclusao ou estorno de liberacao
		dbSelectArea("SAK")
		dbSetOrder(1)
		dbSeek(xFilial()+cAprov)
		cUsuario :=	AK_USER
		nMoeDcto :=	AK_MOEDA
		nTxMoeda	:=	0
	EndIf
	If nOper == 1  //Inclusao do Documento
		cGrupo := If(!Empty(aDocto[6]),aDocto[6],cGrupo)
		dbSelectArea("SAL")
		dbSetOrder(2)
		If !Empty(cGrupo) .And. dbSeek(xFilial("SAL")+cGrupo)
			While !Eof() .And. xFilial("SAL")+cGrupo == AL_FILIAL+AL_COD

                If cTipoDoc <> "NF"  
					If SAL->AL_AUTOLIM == "S" .And. !MaAlcLim(SAL->AL_APROV,nValDcto,nMoeDcto,nTxMoeda)
						dbSelectArea("SAL")
						dbSkip()
						Loop
					EndIf	
                EndIf
                 
				If lFirstNiv
					cAuxNivel := SAL->AL_NIVEL
					lFirstNiv := .F.
				EndIf

				Do Case
				Case cTipoDoc == "NF"
					SF1->(FkCommit())
				Case cTipoDoc == "PC" .Or.cTipoDoc == "AE"
					SC7->(FkCommit())
				Case cTipoDoc == "CP"
					SC3->(FkCommit())
				Case cTipoDoc == "SC"
					SC1->(FkCommit())
				Case cTipoDoc == "CO"
					SC8->(FkCommit())
				Case cTipoDoc == "MD"
					CND->(FkCommit())
				EndCase

				Reclock("SCR",.T.)
				SCR->CR_FILIAL	:= cFilCot 
				SCR->CR_NUM		:= cDocto
				SCR->CR_TIPO	:= cTipoDoc
				SCR->CR_NIVEL	:= SAL->AL_NIVEL
				SCR->CR_USER	:= SAL->AL_USER
				SCR->CR_APROV	:= SAL->AL_APROV
				SCR->CR_STATUS	:= IIF(SAL->AL_NIVEL == cAuxNivel,"02","01")
				SCR->CR_TOTAL	:= nValDcto
				SCR->CR_EMISSAO:= aDocto[10]
				SCR->CR_MOEDA	:=	nMoeDcto
				SCR->CR_TXMOEDA:= nTxMoeda
				MsUnlock()
				dbSelectArea("SAL")
				dbSkip()
			EndDo
		EndIf
		lRetorno := lFirstNiv
	EndIf
	
	If nOper == 2  //Transferencia da Alcada para o Superior
		//dbSelectArea("SCR")
		//dbSetOrder(1)
		//dbSeek(xFilial("SCR")+cTipoDoc+cDocto)
		// O SCR deve estar posicionado, para que seja transferido o atual para o Superior
		If !Eof() .And. SCR->CR_FILIAL+SCR->CR_TIPO+SCR->CR_NUM == xFilial("SCR")+cTipoDoc+cDocto
			// Carrega dados do Registro a ser tranferido e exclui
			cTipoDoc := SCR->CR_TIPO
			cAuxNivel:= SCR->CR_STATUS
			nValDcto := SCR->CR_TOTAL
			nMoeDcto :=	SCR->CR_MOEDA
			cNextNiv := SCR->CR_NIVEL
			nTxMoeda := SCR->CR_TXMOEDA
			dDataRef := SCR->CR_EMISSAO
			cAprovOri:= SCR->CR_APROV
			cUserOri := SCR->CR_USER
			Reclock("SCR",.F.,.T.)
			dbDelete()
			MsUnlock()
			// Inclui Registro para Aprovador Superior
			Reclock("SCR",.T.)
			SCR->CR_FILIAL	:= cFilCot
			SCR->CR_NUM		:= cDocto
			SCR->CR_TIPO	:= cTipoDoc
			SCR->CR_NIVEL	:= cNextNiv
			SCR->CR_USER	:= cUsuario
			SCR->CR_APROV	:= cAprov
			SCR->CR_STATUS	:= cAuxNivel
			SCR->CR_TOTAL	:= nValDcto
			SCR->CR_EMISSAO:= dDataRef
			SCR->CR_MOEDA	:=	nMoeDcto
			SCR->CR_TXMOEDA:= nTxMoeda                     
			SCR->CR_OBS 	:= cObs  
			
			//Aplicar UPDCOM10 se n鉶 existir campos na base //
			If !Empty(SCR->(FieldPos("CR_APRORI"))) .And. !Empty(SCR->(FieldPos("CR_USERORI")))
				SCR->CR_APRORI  := cAprovOri	
				SCR->CR_USERORI := cUserOri
			EndIf

			MsUnlock()
		EndIf
		lRetorno := .T.
	EndIf
	
	If nOper == 3  //exclusao do documento
		dbSelectArea("SAK")
		dbSetOrder(1)
		dbSelectArea("SCR")
		dbSetOrder(1)
		dbSeek(xFilial("SCR")+cTipoDoc+cDocto)		
		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
		//� Efetua uma nova busca caso o cDocto nao for encontrado no SCR�
		//� pois seu conteudo em caso de NF foi alterado para chave unica�
		//� do SF1, o cDocSF1 sera a busca alternativa com o conteudo ori�
		//� ginal do lancamento da versao que poderia causar duplicidades�
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
		If SCR->( Eof() ) .And. cTipoDoc == "NF"
			dbSeek(xFilial("SCR")+cTipoDoc+cDocSF1)
			cDocto := cDocSF1
		EndIf

		While !Eof() .And. SCR->CR_FILIAL+SCR->CR_TIPO+SCR->CR_NUM == xFilial("SCR")+cTipoDoc+cDocto
			If SCR->CR_STATUS == "03"
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//� Reposiciona o usuario aprovador.               �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
				dbSelectArea("SAK")
				dbSeek(xFilial("SAK")+SCR->CR_LIBAPRO)
				dbSelectArea("SAL")
				dbSetOrder(3)
				dbSeek(xFilial("SAL")+cGrupo+SAK->AK_COD)
				If SAL->AL_LIBAPR == "A"
					dbSelectArea("SCS")
					dbSetOrder(2)
					If dbSeek(xFilial("SCS")+SAK->AK_COD+DTOS(MaAlcDtRef(SCR->CR_LIBAPRO,SCR->CR_DATALIB,SCR->CR_TIPOLIM)))
						RecLock("SCS",.F.)
						SCS->CS_SALDO := SCS->CS_SALDO + SCR->CR_VALLIB
						MsUnlock()
					EndIf
				EndIf
			EndIf
			Reclock("SCR",.F.,.T.)
			dbDelete()
			MsUnlock()
			dbSkip()
		EndDo
	EndIf
	
	If nOper == 4 //Aprovacao do documento
		dbSelectArea("SCS")
		dbSetOrder(2)
		aSaldo := MaSalAlc(cAprov,dDataRef,.T.)
		nSaldo 	:= aSaldo[1]
		dDataRef	:= aSaldo[3]
		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
		//� Atualiza o saldo do aprovador.                 �
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
		dbSelectArea("SAK")
		dbSetOrder(1)
		dbSeek(xFilial("SAK")+cAprov)
		
		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
		//� Posiciona a Tabela SAL pelo Aprovador de Origem caso o Documento tenha sido �
		//| transferido por Aus阯cia Tempor醨ia ou Transfer阯cia superior e o aprovador |
		//| de destino n鉶 fizer parte do Grupo de Aprova玢o.                           |
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
		dbSelectArea("SAL")
		dbSetOrder(3)
		dbSeek(xFilial("SAL")+cGrupo+cAprov) 
	    If !Empty(SCR->(FieldPos("CR_USERORI"))) .And. !Empty(SCR->(FieldPos("CR_APRORI"))) .And. !Empty(SCR->CR_APRORI)
    		dbSeek(xFilial("SAL")+cGrupo+SCR->CR_APRORI) 
    	EndIf   
    	
		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
		//� Posiciona a Tabela SAL pelo Aprovador de Origem caso o Documento que esta   �
		//| sendo aprovado, pela opcao: SUPERIOR e o aprovador Superior nao fizer parte |
		//| do mesmo Grupo de Aprova玢o.  									                            |
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
    	If Len(aDocto)>11 .And. !Empty(SCR->(FieldPos("CR_USERORI"))) .And. !Empty(SCR->(FieldPos("CR_APRORI"))) .And. Empty(SCR->CR_APRORI)
	    	If !Empty(aDocto[12])
				dbSeek(xFilial("SAL")+cGrupo+aDocto[12])     	
    		EndIf
    	EndIf                               
		
		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
		//� Libera o pedido pelo aprovador.                     �
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
		dbSelectArea("SCR")
		cAuxNivel := CR_NIVEL
		Reclock("SCR",.F.)
		dbSetOrder(1)
		CR_STATUS	:= "03"
		CR_OBS		:= If(Len(aDocto)>10,aDocto[11],"")
		CR_DATALIB	:= dDataLib
		CR_USERLIB	:= SAK->AK_USER
		CR_LIBAPRO	:= SAK->AK_COD
		CR_VALLIB	:= nValDcto
		CR_TIPOLIM	:= SAK->AK_TIPO
		MsUnlock()
		dbSeek(xFilial("SCR")+cTipoDoc+cDocto+cAuxNivel)
		nRec := RecNo()
		While !Eof() .And. xFilial("SCR")+cDocto+cTipoDoc == CR_FILIAL+CR_NUM+CR_TIPO
			If cAuxNivel == CR_NIVEL .And. CR_STATUS != "03" .And. SAL->AL_TPLIBER$"U "
				Exit
			EndIf
			If cAuxNivel == CR_NIVEL .And. CR_STATUS != "03" .And. SAL->AL_TPLIBER$"NP"
				Reclock("SCR",.F.)
				CR_STATUS	:= "05"
				CR_DATALIB	:= dDataLib
				CR_USERLIB	:= SAK->AK_USER
				CR_APROV	:= cAprov
				CR_OBS		:= ""
				MsUnlock()
			EndIf
			If CR_NIVEL > cAuxNivel .And. CR_STATUS != "03" .And. !lAchou
				lAchou := .T.
				cNextNiv := CR_NIVEL
			EndIf
			If lAchou .And. CR_NIVEL == cNextNiv .And. CR_STATUS != "03"
				Reclock("SCR",.F.)
				CR_STATUS := If(SAL->AL_TPLIBER=="P","05",;
					If(( Empty(cNivIgual) .Or. cNivIgual == CR_NIVEL ) .And. cStatusAnt <> "01" ,"02",CR_STATUS))

				If CR_STATUS == "05"
					CR_DATALIB	:= dDataLib
				EndIf
				MsUnlock()
				cNivIgual := CR_NIVEL					
				lAchou    := .F.
			Endif

			cStatusAnt := SCR->CR_STATUS

			dbSkip()
		EndDo
		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
		//� Reposiciona e verifica se ja esta totalmente liberado.       �
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
		dbGoto(nRec)
		While !Eof() .And. xFilial("SCR")+cTipoDoc+cDocto == CR_FILIAL+CR_TIPO+CR_NUM
			If CR_STATUS != "03" .And. CR_STATUS != "05"
				lRetorno := .F.
			EndIf
			dbSkip()
		EndDo
		If SAL->AL_LIBAPR == "A"
			dbSelectArea("SCS")
			If dbSeek(xFilial()+cAprov+dToS(dDataRef))
				Reclock("SCS",.F.)
			Else
				Reclock("SCS",.T.)                                    
			EndIf
			CS_FILIAL:= xFilial("SCS")
			CS_SALDO := CS_SALDO - nValDcto
			CS_APROV := cAprov
			CS_USER	 := cUsuario
			CS_MOEDA := nMoeDcto
			CS_DATA	 := dDataRef
			MsUnlock()
		EndIf
	EndIf
	
	If nOper == 5  //Estorno da Aprovacao
		cGrupo := If(!Empty(aDocto[6]),aDocto[6],cGrupo)
		dbSelectArea("SAK")
		dbSetOrder(1)
		dbSelectArea("SCR")
		dbSetOrder(1)
		dbSeek(xFilial("SCR")+cTipoDoc+cDocto)
		nMoeDcto := SCR->CR_MOEDA
		nTxMoeda := SCR->CR_TXMOEDA
		While !Eof() .And. SCR->CR_FILIAL+SCR->CR_TIPO+SCR->CR_NUM == xFilial("SCR")+cTipoDoc+cDocto
			If SCR->CR_STATUS == "03"
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//� Reposiciona o usuario aprovador.               �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
				dbSelectArea("SAK")
				dbSeek(xFilial("SAK")+SCR->CR_LIBAPRO)
				
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
				//� Posiciona a Tabela SAL pelo Aprovador de Origem caso o Documento tenha sido �
				//| transferido por Aus阯cia Tempor醨ia ou Transfer阯cia superior e o aprovador |
				//| de destino n鉶 fizer parte do Grupo de Aprova玢o.                           |
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
				dbSelectArea("SAL")
				dbSetOrder(3)
				dbSeek(xFilial("SAL")+cGrupo+SAK->AK_COD)
				If Eof()
				    If !Empty(SCR->(FieldPos("CR_USERORI")))
			    		dbSeek(xFilial("SAL")+cGrupo+SCR->CR_APRORI) 
	    			EndIf
	   			EndIf
	   			
				If SAL->AL_LIBAPR == "A"
					dbSelectArea("SCS")
					dbSetOrder(2)
					If dbSeek(xFilial("SCS")+SAK->AK_COD+DTOS(MaAlcDtRef(SAK->AK_COD,SCR->CR_DATALIB)))
						RecLock("SCS",.F.)
						SCS->CS_SALDO := SCS->CS_SALDO + If(nValDcto>0 .And. nValDcto < SCR->CR_VALLIB,nValDcto,SCR->CR_VALLIB)
						If SCS->CS_SALDO > SAK->AK_LIMITE
							SCS->CS_SALDO := SAK->AK_LIMITE
						EndIf
						MsUnlock()
					EndIf
				EndIf
			EndIf
			Reclock("SCR",.F.,.T.)
			If nValDcto > 0 .And. nValDcto < SCR->CR_TOTAL
				SCR->CR_TOTAL	:= SCR->CR_TOTAL  - nValDcto
				SCR->CR_VALLIB	:= SCR->CR_VALLIB - nValDcto
			Else
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//矨 variavel lResiduo informa se devera ou nao reconstituir um  �
				//硁ovo bloqueio SCR  se ainda houver saldo apos a eliminacao de �
				//硆esiduos, em caso da opcao de estorno a reconstituicao do SCR �
				//砮 obrigatoria, apos a delecao.                                �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁		
				If lResiduo
					lDeletou := IF(SCR->CR_TOTAL - nValDcto > 0,.T.,.F.)
				Else
					lDeletou := .T.
				EndIf
				dbDelete()
			EndIf
			MsUnlock()
			dbSkip()
		EndDo

		dbSelectArea("SAL")
		dbSetOrder(2)
		If	(!Empty(cGrupo) .And. dbSeek(xFilial("SAL")+cGrupo) .And. nValDcto > 0 .And. lDeletou) .Or. ;
			(!Empty(cGrupo) .And. dbSeek(xFilial("SAL")+cGrupo) .And. cTipoDoc == "NF" .And. lDeletou)
			
			While !Eof() .And. xFilial("SAL")+cGrupo == AL_FILIAL+AL_COD

                If cTipoDoc <> "NF"  
					If SAL->AL_AUTOLIM == "S" .And. !MaAlcLim(SAL->AL_APROV,nValDcto,nMoeDcto,nTxMoeda)
						dbSelectArea("SAL")
						dbSkip()
						Loop
					EndIf             	
                EndIf
                 				
				If lFirstNiv
					cAuxNivel := SAL->AL_NIVEL
					lFirstNiv := .F.
				EndIf
				Reclock("SCR",.T.)
				SCR->CR_FILIAL	:= SC8->C8_FILIAL
				SCR->CR_NUM		:= cDocto
				SCR->CR_TIPO	:= cTipoDoc
				SCR->CR_NIVEL	:= SAL->AL_NIVEL
				SCR->CR_USER	:= SAL->AL_USER
				SCR->CR_APROV	:= SAL->AL_APROV
				SCR->CR_STATUS	:= IIF(SAL->AL_NIVEL == cAuxNivel,"02","01")
				SCR->CR_TOTAL	:= nValDcto
				SCR->CR_EMISSAO:= dDataRef
				SCR->CR_MOEDA	:=	nMoeDcto
				SCR->CR_TXMOEDA:= nTxMoeda
				MsUnlock()
				dbSelectArea("SAL")
				dbSkip()
			EndDo
		EndIf
		lRetorno := lFirstNiv
	EndIf
	
	If nOper == 6  //Bloqueio manual
		dbSelectArea("SAK")
		dbSetOrder(1)
		dbSeek(xFilial("SAK")+cAprov)
	
		Reclock("SCR",.F.)
		CR_STATUS   := "04"
		CR_OBS	    := If(Len(aDocto)>10,aDocto[11],"")
		CR_DATALIB  := dDataRef
		CR_USERLIB	:= SAK->AK_USER
		CR_LIBAPRO	:= SAK->AK_COD
		cAuxNivel   := CR_NIVEL
		MsUnlock()
		lRetorno 	:= .F.
		
		//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
		//� Bloqueia todos os Aprovadores do N韛el  �
		//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
		dbSeek(xFilial("SCR")+cTipoDoc+cDocto+cAuxNivel)
		nRec := RecNo()
		While !Eof() .And. xFilial("SCR")+cDocto+cTipoDoc+cAuxNivel == CR_FILIAL+CR_NUM+CR_TIPO+CR_NIVEL
			If CR_STATUS != "04" 
				Reclock("SCR",.F.)
				CR_STATUS	:= "05"
				CR_OBS	    := SAK->AK_COD
				CR_DATALIB	:= dDataRef
				CR_USERLIB	:= SAK->AK_USER
				CR_LIBAPRO	:= SAK->AK_COD
				MsUnlock()
			EndIf             
			                                           
			dbSkip()
		EndDo
	EndIf

	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
	//� Integracao ACC envia aprovacao do pedido            �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪�
	If lRetorno .And. cTipoDoc == "PC" .And. (nOper == 1 .Or. nOper == 4) .And. If(FindFunction("WebbConfig"),WebbConfig(),.F.)
		aAreaSC7 := SC7->(GetArea())
		
		SC7->(dbSetOrder(1))
		If SC7->(dbSeek(xFilial("SC7")+AllTrim(cDocto))) .And. !Empty(SC7->C7_ACCNUM)	
			If IsBlind()
				Webb533(SC7->C7_NUM)
			Else
				MsgRun("Aguarde, comunicando aprova玢o ao portal...","Portal ACC",{|| Webb533(SC7->C7_NUM)})	//Aguarde, comunicando aprova玢o ao portal... ## Portal ACC
			EndIf
		EndIf
		
		dbSelectArea("SC7")
		RestArea(aAreaSC7)
	EndIf
		
EndIf

dbSelectArea("SCR")
RestArea(aAreaSCR)
dbSelectArea("SCS")
RestArea(aAreaSCS)
RestArea(aArea)

Return(lRetorno)
    
/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲uncao    � MaFisRet � Autor � Edson Maricate        � Data �08.12.1999潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噮o � Retorna os impostos calculados pela MATXFIS.               潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砇etorno   矱xpN1: Valor do imposto.                                    潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�/*/
User Function MaFisRet(nItem,cCampo)

Local nRetorno
Local cPosCpo := MaFisScan(cCampo)

Do Case
Case Substr(cCampo,1,2) == "IT"
	If ValType(cPosCpo) == "A"
		nRetorno:=aNfItem[nItem][cPosCpo[1]][cPosCpo[2]]
	Else
		If nItem == Nil
			nRetorno:=aNfItem[1][Val(cPosCpo)]
			else
			nRetorno:=aNfItem[nItem][Val(cPosCpo)]
		EndIf
	EndIf
Case Substr(cCampo,1,2) == "LF"
	If nItem == Nil
		nRetorno:=aNfItem[nItem][NF_LIVRO][cPosCpo]
	Else
		nRetorno:=aNfItem[nItem][IT_LIVRO][cPosCpo]
	EndIf
OtherWise
	If ValType(cPosCpo) == "A"
		nRetorno:=aNfCab[cPosCpo[1]][cPosCpo[2]]
	Else
		nRetorno:=aNfCab[Val(cPosCpo)]
	EndIf
EndCase

Return nRetorno

********************************************************************************************************************************************************
User Function MaMontaCot(aCabec,aPlanilha,aAuditoria,aCotacao,aListBox,aRefImpos,lTes,lVisual,lProceCot,cProdCot,cItemCotID,lFirsT,aSC8,aCpoSC8)        
********************************************************************************************************************************************************

Local aArea 	  := GetArea()
Local aAreaSX3    := SX3->(GetArea())
Local aStruQry	  := SC8->(dbStruct())
Local aStruTmp    := {}
Local aCampoSC8   := {}
Local aRetM160PL  := {}
Local aRetStru    := {}
Local aScanGrd    := {}

Local cNumSC8     
Local cFilSC8     
Local cAliasSC8   := "SC8"
Local cQuery	  := ""
Local cIdentSC8   := ""
Local cGrupCom    := ""
Local cProdRef    := ""
Local cFiltro     := ".T."

Local lVerifica   :=  GetMV("MV_QBLQFOR",,"N") == "S"
Local lSigaGSP    :=  GetNewPar("MV_SIGAGSP","0")=="0"
Local lMtxFisCo   :=  GetNewPar('MV_PERFORM',.T.) //Indica se ira utilizar as funcoes fiscais para calcular o valor presente
Local lSolic      :=  SuperGetMv("MV_RESTCOM")=="S"
Local lQuery	  := .F.
Local lGrupCom    := .T.
Local lPedido     := .T.
Local lRetorno    := .F.
Local lReferencia := .F. 
Local lGrade      := MaGrade()

Local nP		  := 0
Local nX		  := 0
Local nY		  := 0
Local nZ		  := 0
Local nPosRef1    := 0
Local nPosRef2    := 0
Local nCusto      := 0
Local nUsadoSC8   := 0
Local nUsadoSCE   := 0
Local nScan       := 0
Local nSC8Fornec  := 0
Local nSC8Loja    := 0
Local nSC8NumPro  := 0
Local nSC8Item    := 0
Local nSC8Quant   := 0
Local nSC8Preco   := 0
Local nSC8Total   := 0
Local nSC8Scan    := 0
Local nPlanScan   := 0
Local nPlanFornec := 0
Local nPlanLoja   := 0
Local nPlanNumPro := 0
Local nPlanItem   := 0
Local nPlanPreco  := 0
Local nPlanTotal  := 0

DEFAULT aPlanilha  := {}
DEFAULT aAuditoria := {}
DEFAULT aCotacao   := {}
DEFAULT aListBox   := {}
DEFAULT aSC8       := {}
DEFAULT aCabec     := Array(12)
DEFAULT aCabec[CAB_HFLD1] := {}
DEFAULT aCabec[CAB_HFLD2] := {}
DEFAULT aCabec[CAB_HFLD3] := {}
DEFAULT aRefImpos  := {}
DEFAULT lTES	   := .F.
DEFAULT lVisual	   := .F.
DEFAULT lProceCot  := .T. 
DEFAULT lFirsT     := .T.
DEFAULT cProdCot   := " "
DEFAULT cItemCotID := " "
DEFAULT aCpoSC8    := {}

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Efetua a montagem da planilha de fornecimento                          �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("SC8")
While ( !Eof() .And. SX3->X3_ARQUIVO == "SC8" )
	If ( X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And.;
			SX3->X3_CONTEXT<>"V" .And. !Trim(SX3->X3_CAMPO)$"C8_ITEM" )
		If lMtxFisCo
			nUsadoSC8++
			If lFirsT
				AADD(aCabec[CAB_HFLD3],TRIM(X3Titulo()))
			Endif	
			AADD(aCampoSC8,{SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TIPO})
		Else
			If Trim(SX3->X3_CAMPO)$ "C8_NUMPRO#C8_NUMSC#C8_ITEMSC#C8_PRODUTO#C8_PRECO#C8_QUANT#C8_TOTAL#C8_AVISTA"
				nUsadoSC8++
				If lFirsT
					AADD(aCabec[CAB_HFLD3],TRIM(X3Titulo()))
				Endif	
				AADD(aCampoSC8,{SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TIPO})
			Endif	
		Endif	
	EndIf
	If lFirsT
		nPosRef1	:= At("MAFISREF(",Upper(SX3->X3_VALID))
		If ( nPosRef1 > 0 )
			nPosRef1    += 10
			nPosRef2    := At(",",SubStr(SX3->X3_VALID,nPosRef1))-2
			aadd(aRefImpos,{"SC8",SX3->X3_CAMPO,SubStr(SX3->X3_VALID,nPosRef1,nPosRef2)})
		EndIf
	Endif	
	dbSelectArea("SX3")
	dbSkip()
EndDo
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Efetua a montagem da planilha de auditoria                             �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("SCE")
While ( !Eof() .And. SX3->X3_ARQUIVO == "SCE" )
	If ( X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL ) .Or. AllTrim(SX3->X3_CAMPO) == "CE_NUMPRO"
		If ! AllTrim(SX3->X3_CAMPO) $ "CE_NUMCOT; CE_ITEMCOT"
			nUsadoSCE++
			If lFirsT
				AADD(aCabec[CAB_HFLD2],{ TRIM(X3Titulo()),;
					Trim(SX3->X3_CAMPO),;
					SX3->X3_PICTURE,;
					SX3->X3_TAMANHO,;
					SX3->X3_DECIMAL,;
					SX3->X3_VALID,;
					SX3->X3_USADO,;
					SX3->X3_TIPO,;
					SX3->X3_ARQUIVO,;
					SX3->X3_CONTEXT } )
			Endif	
		Endif
	EndIf
	dbSelectArea("SX3")
	dbSkip()
EndDo

If aScan(aCabec[CAB_HFLD2], {|z| AllTrim(z[2]) == "CE_ITEMCOT"}) == 0
	dbSetOrder(2)
	dbSeek(Pad("CE_ITEMCOT", 10))
	nUsadoSCE++
	AADD(aCabec[CAB_HFLD2],{ TRIM(X3Titulo()),;
		Trim(SX3->X3_CAMPO),;
		SX3->X3_PICTURE,;
		SX3->X3_TAMANHO,;
		SX3->X3_DECIMAL,;
		SX3->X3_VALID,;
		SX3->X3_USADO,;
		SX3->X3_TIPO,;
		SX3->X3_ARQUIVO,;
		SX3->X3_CONTEXT } )
	dbSetOrder(1)
Endif

If aScan(aCabec[CAB_HFLD2], {|z| AllTrim(z[2]) == "CE_NUMCOT"}) == 0
	dbSetOrder(2)
	dbSeek(Pad("CE_NUMCOT", 10))
	nUsadoSCE++
	AADD(aCabec[CAB_HFLD2],{ TRIM(X3Titulo()),;
		Trim(SX3->X3_CAMPO),;
		SX3->X3_PICTURE,;
		SX3->X3_TAMANHO,;
		SX3->X3_DECIMAL,;
		SX3->X3_VALID,;
		SX3->X3_USADO,;
		SX3->X3_TIPO,;
		SX3->X3_ARQUIVO,;
		SX3->X3_CONTEXT } )
	dbSetOrder(1)
Endif

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪目
//砏alk Thru                   �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪馁
ADHeadRec("SCE",aCabec[CAB_HFLD2])

If lFirsT
	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//� Efetua a preparacao dos dados que serao mostrados na planilha          �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	aadd(aCabec[CAB_HFLD1],{"PLN_OK"     ,"","",""})
	aadd(aCabec[CAB_HFLD1],{"PLN_FORNECE","",RetTitle("C8_FORNECE"),PesqPict("SC8","C8_FORNECE")})
	aadd(aCabec[CAB_HFLD1],{"PLN_LOJA"   ,"",RetTitle("C8_LOJA"),PesqPict("SC8","C8_LOJA")})
	aadd(aCabec[CAB_HFLD1],{"PLN_NREDUZ" ,"",RetTitle("A2_NREDUZ"),PesqPict("SA2","A2_NREDUZ")})
	aadd(aCabec[CAB_HFLD1],{"PLN_QUANT"  ,"",RetTitle("C8_QUANT"),PesqPict("SC8","C8_QUANT")})
	aadd(aCabec[CAB_HFLD1],{"PLN_PRECO"  ,"",RetTitle("C8_PRECO"),PesqPict("SC8","C8_PRECO")})
	aadd(aCabec[CAB_HFLD1],{"PLN_TOTAL"  ,"",RetTitle("C8_TOTAL"),PesqPict("SC8","C8_TOTAL")})
	aadd(aCabec[CAB_HFLD1],{"PLN_DESCRI" ,"",RetTitle("E4_DESCRI"),PesqPict("SE4","E4_DESCRI")})
	aadd(aCabec[CAB_HFLD1],{"PLN_COND"   ,"",RetTitle("C8_COND"),PesqPict("SC8","C8_COND")})
	aadd(aCabec[CAB_HFLD1],{"PLN_DATPRF" ,"",RetTitle("C8_DATPRF"),PesqPict("SC8","C8_DATPRF")})
	aadd(aCabec[CAB_HFLD1],{"PLN_VLDESC" ,"",RetTitle("C8_VLDESC"),PesqPict("SC8","C8_VLDESC")})
	aadd(aCabec[CAB_HFLD1],{"PLN_NUMPRO" ,"",RetTitle("C8_NUMPRO"),PesqPict("SC8","C8_NUMPRO")})
	aadd(aCabec[CAB_HFLD1],{"PLN_DATPRZ" ,"",RetTitle("C8_PRAZO"),PesqPict("SC8","C8_PRAZO")})
	aadd(aCabec[CAB_HFLD1],{"PLN_DESVIO" ,"",RetTitle("A2_DESVIO"),PesqPict("SA2","A2_DESVIO")})
	aadd(aCabec[CAB_HFLD1],{"PLN_NOTA"   ,"",RetTitle("A5_NOTA"),PesqPict("SA5","A5_NOTA")})
	aadd(aCabec[CAB_HFLD1],{"C8_ZOBSADI" ,"",RetTitle("C8_ZOBSADI"),PesqPict("SC8","C8_ZOBSADI")})  
	aadd(aCabec[CAB_HFLD1],{"PLN_ITEM"   ,"",RetTitle("C8_ITEM"),PesqPict("SC8","C8_ITEM")})
	aadd(aCabec[CAB_HFLD1],{"PLN_PRAZO"  ,"",RetTitle("C8_PRAZO"),PesqPict("SC8","C8_PRAZO")})
	aadd(aCabec[CAB_HFLD1],{"PLN_VISTO"  ,"","",""})
	aadd(aCabec[CAB_HFLD1],{"PLN_ITEMGRD","",RetTitle("C8_ITEMGRD"),PesqPict("SC8","C8_ITEMGRD")})

	dbSelectArea("SX3")
	dbSetOrder(2)
	MsSeek("C8_FORNECE")
	aadd(aStruTmp,{"PLN_OK","C",2,0})
	aadd(aStruTmp,{"PLN_FORNEC",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	MsSeek("C8_LOJA")
	aadd(aStruTmp,{"PLN_LOJA",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	MsSeek("A2_NREDUZ")
	aadd(aStruQry,{"A2_NREDUZ",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	aadd(aStruTmp,{"PLN_NREDUZ",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	MsSeek("C8_QUANT")
	aadd(aStruTmp,{"PLN_QUANT",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	MsSeek("C8_PRECO")
	aadd(aStruTmp,{"PLN_PRECO",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	MsSeek("C8_TOTAL")
	aadd(aStruTmp,{"PLN_TOTAL",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	MsSeek("E4_DESCRI")
	aadd(aStruTmp,{"PLN_DESCRI",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	MsSeek("C8_COND")
	aadd(aStruTmp,{"PLN_COND",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	MsSeek("C8_DATPRF")
	aadd(aStruTmp,{"PLN_DATPRF",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	MsSeek("C8_VLDESC")
	aadd(aStruTmp,{"PLN_VLDESC",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	MsSeek("C8_NUMPRO")
	aadd(aStruTmp,{"PLN_NUMPRO",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	aadd(aStruTmp,{"PLN_DATPRZ",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	MsSeek("A2_DESVIO")
	aadd(aStruQry,{"A2_DESVIO",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	aadd(aStruTmp,{"PLN_DESVIO",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	MsSeek("A5_NOTA")
	aadd(aStruTmp,{"PLN_NOTA",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	MsSeek("C8_ZOBSADI")
	aadd(aStruTmp,{"C8_ZOBSADI",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	MsSeek("C8_ITEM")
	aadd(aStruTmp,{"PLN_ITEM",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	MsSeek("C8_PRAZO")
	aadd(aStruTmp,{"PLN_PRAZO",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
	MsSeek("C8_ITEMGRD")
	aadd(aStruTmp,{"PLN_VISTO","C",1,0})
	aadd(aStruTmp,{"PLN_ITEMGR",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//� Preenche array aCpoSC8 com os campos do cabecalho para permitir alterar�
	//� a ordem dos campos                                                     �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁	
	aEval( aCabec[CAB_HFLD1] , { |x| aAdd( aCpoSC8 , x[1] ) } )

	//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//� Cria o arquivo temporario                                              �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
	aCabec[CAB_ARQTMP] := CriaTrab(aStruTmp,.T.)
	dbUseArea(.T.,__LocalDrive,aCabec[CAB_ARQTMP],aCabec[CAB_ARQTMP],.F.,.F.)
Else
	dbSelectArea("SX3")
	dbSetOrder(2)
	MsSeek("A2_NREDUZ")
	aadd(aStruQry,{"A2_NREDUZ",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

	MsSeek("A2_DESVIO")
	aadd(aStruQry,{"A2_DESVIO",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
Endif	

//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Efetua a montagem das paginas de cotacao                               �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
DbSelectArea("SC8")
DbSetOrder (1)
IF dbSeek(aWBrowse2[oWBrowse2:nAt,9]+aWBrowse2[oWBrowse2:nAt,3])
 nReg := Recno()
Endif  
DbGoto(nReg)
cNumSC8 := SC8->C8_NUM
cFilSC8 := SC8->C8_FILIAL

#IFDEF TOP
	cAliasSC8:= "MAMONTACOT"
	lQuery := .T.
	cQuery := ""
	For nX := 1 To Len(aStruQry)
		cQuery += ","+aStruQry[nX][1]
	Next nX
	cQuery := "SELECT SB1.B1_TE,"+SubStr(cQuery,2)+",SC8.R_E_C_N_O_ SC8RECNO "
	cQuery += "FROM "+RetSqlName("SC8")+" SC8,"
	cQuery += RetSqlName("SA2")+" SA2,"
	cQuery += RetSqlName("SB1")+" SB1 "
	cQuery += "WHERE SC8.C8_FILIAL='"+cFilSC8+"' AND "
	cQuery += "SC8.C8_NUM='"+cNumSC8+"' AND "
	If !lProceCot .And. !Empty(cProdCot) .And. !Empty(cItemCotID)
		cQuery += "SC8.C8_PRODUTO = '"+cProdCot+"' AND "
		cQuery += "SC8.C8_IDENT   = '"+cItemCotID+"' AND "
	Endif
	cQuery += "SC8.D_E_L_E_T_= ' ' AND "
	cQuery += "SA2.A2_FILIAL='"+xFilial("SA2")+"' AND "
	cQuery += "SA2.A2_COD=SC8.C8_FORNECE AND "
	cQuery += "SA2.A2_LOJA=SC8.C8_LOJA AND "
	cQuery += "SA2.D_E_L_E_T_=' ' AND "
	cQuery += "SB1.B1_FILIAL='"+xFilial("SB1")+"' AND "
	cQuery += "SB1.B1_COD=SC8.C8_PRODUTO AND "
	cQuery += "SB1.D_E_L_E_T_=' ' "
	cQuery += "ORDER BY C8_ITEM, C8_FORNECE"//+SqlOrder(SC8->(IndexKey()))
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC8,.T.,.T.)
	For nX := 1 To Len(aStruQry)
		If ( aStruQry[nX][2] <> "C" )
			TcSetField(cAliasSC8,aStruQry[nX][1],aStruQry[nX][2],aStruQry[nX][3],aStruQry[nX][4])
		EndIf
	Next nX	
#ENDIF

dbSelectArea(cAliasSC8)
While ( !Eof() .And. (cAliasSC8)->C8_FILIAL == cFilSC8 .And. (cAliasSC8)->C8_NUM == cNumSC8 )
	
	If ( !lQuery )
		If !lProceCot .And. !Empty(cProdCot) .And. !Empty(cItemCotID)
			If RetCodProdFam((cAliasSC8)->C8_PRODUTO) <> RetCodProdFam(cProdCot) .And. (cAliasSC8)->C8_IDENT <> cItemCotID
				dbSelectArea(cAliasSC8)
				dbSkip()
				Loop
			Endif
		Endif
	Endif
    
    //谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
	//� Verifica se o filtro utilizado e valido senao substitui por ".T."      �
	//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
    If Valtype(cFiltro) == "C" .And. Empty(cFiltro)
    	cFiltro:= ".T."
    ElseIf Valtype(cFiltro) != "C"
    	cFiltro:= ".T."
    EndIf
    
	//If &(cFiltro)  .And. If( lSigaGSP,.t.,GSPF190() )
		
		//If !lVisual .And. lSolic .And. !VldAnCot(RetCodUsr(),(cAliasSC8)->C8_GRUPCOM)
		  //	cGrupCom  := (cAliasSC8)->C8_GRUPCOM
		//Else

			lGrupCom  := .F.

			If lVisual .Or. Empty((cAliasSC8)->C8_NUMPED)

				lPedido   := .F.
				
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//� Verifica se o Produto x Fornecedor esta definido para Inspecao no QIE, �
				//� se o mesmo possui a Situacao; "Nao-Habilitado, neste caso o mesmo nao  �
				//� sera selecionado para analise nas cotacoes. 						   �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
				If !lVisual .And. lVerifica
					If !QieSitFornec((cAliasSC8)->C8_FORNECE,(cAliasSC8)->C8_LOJA,(cAliasSC8)->C8_PRODUTO,.F.)
						dbSelectArea(cAliasSC8)
						dbSkip()
						Loop
					EndIf
				EndIf
						
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//� Calculo do custo da Cotacao                                            �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
				If lMtxFisCo
					nMoedaAval := Max((cAliasSC8)->C8_MOEDA,1)
					MaFisIni((cAliasSC8)->C8_FORNECE,(cAliasSC8)->C8_LOJA,"F","N","R")
					MaFisIniLoad(1)
					For nY := 1 To Len(aRefImpos)
						MaFisLoad(aRefImpos[nY][3],(cAliasSC8)->(FieldGet(FieldPos(aRefImpos[nY][2]))),1)
					Next nY
					If ( lTes .And. Empty((cAliasSC8)->C8_TES) )
						If ( !lQuery )
							dbSelectArea("SB1")
							dbSetOrder(1)
							MsSeek(xFilial("SB1")+(cAliasSC8)->C8_PRODUTO)
							MaFisAlt("IT_TES",RetFldProd(SB1->B1_COD,"B1_TE"),1)
						Else
							MaFisAlt("IT_TES",RetFldProd((cAliasSC8)->C8_PRODUTO,"B1_TE"),1)
						EndIf
					EndIf
					MaFisEndLoad(1)
					nCusto := (cAliasSC8)->C8_QUANT * (cAliasSC8)->C8_PRECO//Ma160Custo(cAliasSC8,1)
					MaFisEnd()
				Else
					nCusto := (cAliasSC8)->C8_QUANT * (cAliasSC8)->C8_PRECO//Ma160Custo(cAliasSC8,1)
				Endif
                                                                                                                                
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//� Quando o C8_CR for diferente sera construida uma nova dimensao em   �
				//� todo conjunto de Arrays da Analise para paginar um novo produto, isso  �
				//� so nao ocorrera se o Produto for um produto com item de Grade, neste   �
				//� caso o C8_IDENT e o mesmo para todos os itens com Grade e os arrays    �
				//� aPlanilha,aCotacao e aAuditoria sao construido de forma Sintetica.     �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁

				If cIdentSC8 <> (cAliasSC8)->C8_IDENT //.AND. nNumPla == 0
				    nNumPla := 1 
					cIdentSC8:= (cAliasSC8)->C8_IDENT
					aadd(aPlanilha,{})
					aadd(aCotacao,{})
					aadd(aAuditoria,{})
					aadd(aListBox,{})
					nX 		 := Len(aPlanilha)
					//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
					//� Array usado para Gravacao do PC pela Analise da Cotacao na MaAvalCot   �
					//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
					aadd(aSC8,{})
					nP 		:= Len(aSC8)
				Endif

				aadd(aSC8[nP],{})
				nY := Len(aSC8[nP])
				dbSelectArea(cAliasSC8)
				For nZ := 1 To FCount()
					If FieldName(nZ) $ "C8_NUMPRO#C8_FORNECE#C8_LOJA#C8_COND#C8_PRODUTO#C8_ITEM#C8_NUM#C8_ITEMGRD#SC8RECNO#C8_FILENT"
						aadd(aSC8[nP][nY],{FieldName(nZ),FieldGet(nZ)})
					Endif
				Next nZ
				If !lQuery 
					aadd(aSC8[nP][nY],{"SC8RECNO",(cAliasSC8)->(RecNo())})
				EndIf
			
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//� Planilha de cotacao                                                    �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁				
				If !lGrade .Or. Empty((cAliasSC8)->C8_ITEMGRD) .Or. aScan(aScanGrd, {|z| z[1] + z[2] + z[3] + z[4] == (cAliasSC8)->(C8_FORNECE+C8_LOJA+C8_NUMPRO+C8_ITEM)}) == 0

					Aadd(aScanGrd, {(cAliasSC8)->C8_FORNECE, (cAliasSC8)->C8_LOJA, (cAliasSC8)->C8_NUMPRO, (cAliasSC8)->C8_ITEM, (cAliasSC8)->(Recno())})

					cProdRef   := (cAliasSC8)->C8_PRODUTO
					lReferencia:= MatGrdPrrf(@cProdRef,.T.)
					dbSelectArea("SA5")
					dbSetOrder(1)
					If ! MsSeek(xFilial("SA5")+(cAliasSC8)->C8_FORNECE+(cAliasSC8)->C8_LOJA+(cAliasSC8)->C8_PRODUTO).And.lReferencia
						dbSelectArea("SA5")
						dbSetOrder(9)
						MsSeek(xFilial("SA5")+(cAliasSC8)->C8_FORNECE+(cAliasSC8)->C8_LOJA+cProdRef )
					Endif

					SE4->(dbSetOrder(1))
					SE4->(MsSeek(xFilial("SE4")+(cAliasSC8)->C8_COND))
										
					If !( lQuery )
						dbSelectArea("SA2")
						dbSetOrder(1)
						MsSeek(xFilial("SA2")+(cAliasSC8)->C8_FORNECE+(cAliasSC8)->C8_LOJA)
					EndIf
					
					aAdd(aPlanilha[nx],Array(len(aCpoSC8)))
					
					For ny:=1 to len(aCpoSC8)
						Do Case
							Case aCpoSC8[ny] == "PLN_DESCRI"
								aPlanilha[nx,len(aPlanilha[nx]),ny] := SE4->E4_DESCRI
							Case aCpoSC8[ny] == "PLN_NOTA"
								aPlanilha[nx,len(aPlanilha[nx]),ny] := SA5->A5_NOTA
							Case aCpoSC8[ny] == "PLN_DESVIO"
								aPlanilha[nx,len(aPlanilha[nx]),ny] := If(lQuery,(cAliasSC8)->A2_DESVIO,SA2->A2_DESVIO)
							Case aCpoSC8[ny] == "PLN_NREDUZ"
								aPlanilha[nx,len(aPlanilha[nx]),ny] := If(lQuery,(cAliasSC8)->A2_NREDUZ,SA2->A2_NREDUZ)
							Case aCpoSC8[ny] == "PLN_OK"
								aPlanilha[nx,len(aPlanilha[nx]),ny] := Space(2)
							Case aCpoSC8[ny] == "PLN_TOTAL"
								aPlanilha[nx,len(aPlanilha[nx]),ny] := nCusto
							Case aCpoSC8[ny] == "PLN_DATPRZ"
								aPlanilha[nx,len(aPlanilha[nx]),ny] := dDataBase+(cAliasSC8)->C8_PRAZO
							Case aCpoSC8[ny] == "PLN_PRECO"
								aPlanilha[nx,len(aPlanilha[nx]),ny] := xMoeda((cAliasSC8)->C8_PRECO,(cAliasSC8)->C8_MOEDA,1,(cAliasSC8)->C8_EMISSAO,,If((cAliasSC8)->(FIELDPOS("C8_TXMOEDA")) > 0,(cAliasSC8)->C8_TXMOEDA,''))
							Case aCpoSC8[ny] == "PLN_VISTO"
								aPlanilha[nx,len(aPlanilha[nx]),ny] := " "
							Case aCpoSC8[ny] == "PLN_OBS"
								aPlanilha[nx,len(aPlanilha[nx]),ny] := (cAliasSC8)->C8_ZOBSADI	
							OtherWise
								aPlanilha[nx,len(aPlanilha[nx]),ny] := (cAliasSC8)->&("C8_"+substr(aCpoSC8[ny],at("_",aCpoSC8[ny])+1))
						EndCase
					Next

					//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
					//� Armazenna posicao dos campos da planilha                               �
					//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
					nPlanFornec := aScan(aCpoSC8,"PLN_FORNEC")
					nPlanLoja   := aScan(aCpoSC8,"PLN_LOJA")
					nPlanNumPro := aScan(aCpoSC8,"PLN_NUMPRO")
					nPlanItem   := aScan(aCpoSC8,"PLN_ITEM")
					nPlanPreco  := aScan(aCpoSC8,"PLN_PRECO")
					nPlanTotal  := aScan(aCpoSC8,"PLN_TOTAL")

					//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
					//� Dados da cotacao                                                       �
					//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
					aadd(aCotacao[nX],{})
					nY := Len(aCotacao[nX])
					dbSelectArea(cAliasSC8)
					For nZ := 1 To FCount()
						If lMtxFisCo
							aadd(aCotacao[nX][nY],{FieldName(nZ),FieldGet(nZ)})
						Else
							If FieldName(nZ) $ "C8_NUM#C8_ITEM#C8_NUMPRO#C8_FORNECE#C8_LOJA#C8_PRODUTO#C8_QUANT#C8_NUMSC#C8_ITEMSC#C8_TAXAFIN#C8_COND#SC8RECNO#C8_QTDAUDI#C8_ITEMGRD"
								aadd(aCotacao[nX][nY],{FieldName(nZ),FieldGet(nZ)})
							Endif
						Endif
					Next nZ
					If ( !lQuery )
						aadd(aCotacao[nX][nY],{"SC8RECNO",(cAliasSC8)->(RecNo())})
					EndIf
					
					nSC8Fornec  := aScan(aCotacao[nX, nY], {|z| AllTrim(z[1]) == "C8_FORNECE"})
					nSC8Loja    := aScan(aCotacao[nX, nY], {|z| AllTrim(z[1]) == "C8_LOJA"   })
					nSC8NumPro  := aScan(aCotacao[nX, nY], {|z| AllTrim(z[1]) == "C8_NUMPRO" })
					nSC8Item    := aScan(aCotacao[nX, nY], {|z| AllTrim(z[1]) == "C8_ITEM"   })
					nSC8Quant   := aScan(aCotacao[nX, nY], {|z| AllTrim(z[1]) == "C8_QUANT"  })
					nSC8Preco   := aScan(aCotacao[nX, nY], {|z| AllTrim(z[1]) == "C8_PRECO"  })
					nSC8Total   := aScan(aCotacao[nX, nY], {|z| AllTrim(z[1]) == "C8_TOTAL"  })

					//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
					//� Planilha de Auditoria                                                  �
					//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
					aadd(aAuditoria[nX],Array(Len(aCabec[CAB_HFLD2])+1))
					For nY := 1 To Len(aCabec[CAB_HFLD2])
						Do Case
							Case IsHeadRec(aCabec[CAB_HFLD2][nY][2])
								aAuditoria[nX][Len(aAuditoria[nX])][nY] := IIf(lQuery , (cAliasSC8)->SC8RECNO , (cAliasSC8)->(Recno()) )
							Case IsHeadAlias(aCabec[CAB_HFLD2][nY][2])
								aAuditoria[nX][Len(aAuditoria[nX])][nY] := "SC8"
							Case aCabec[CAB_HFLD2][nY][2]=="CE_NUMPRO"
								aAuditoria[nX][Len(aAuditoria[nX])][nY] := (cAliasSC8)->C8_NUMPRO
							Case aCabec[CAB_HFLD2][nY][2]=="CE_FORNECE"
								aAuditoria[nX][Len(aAuditoria[nX])][nY] := (cAliasSC8)->C8_FORNECE
							Case aCabec[CAB_HFLD2][nY][2]=="CE_LOJA"
								aAuditoria[nX][Len(aAuditoria[nX])][nY] := (cAliasSC8)->C8_LOJA
							Case  aCabec[CAB_HFLD2][nY][2]=="CE_ENTREGA"
								aAuditoria[nX][Len(aAuditoria[nX])][nY] := (cAliasSC8)->C8_DATPRF
							Case  aCabec[CAB_HFLD2][nY][2]=="CE_ITEMCOT"
								aAuditoria[nX][Len(aAuditoria[nX])][nY] := (cAliasSC8)->C8_ITEM
							Case  aCabec[CAB_HFLD2][nY][2]=="CE_NUMCOT"
								aAuditoria[nX][Len(aAuditoria[nX])][nY] := (cAliasSC8)->C8_NUM
							Case  aCabec[CAB_HFLD2][nY][2]=="CE_ITEMGRD"
								aAuditoria[nX][Len(aAuditoria[nX])][nY] := (cAliasSC8)->C8_ITEMGRD
							Case  aCabec[CAB_HFLD2][nY][2]=="CE_QUANT"
								dbSelectArea("SCE")
								dbSetOrder(1)
								If MsSeek(xFilial("SCE")+(cAliasSC8)->C8_NUM+(cAliasSC8)->C8_ITEM+(cAliasSC8)->C8_PRODUTO+;
									(cAliasSC8)->C8_FORNECE+(cAliasSC8)->C8_LOJA)
									While SCE->(!Eof()) .And. SCE->CE_FILIAL+SCE->CE_NUMCOT+SCE->CE_ITEMCOT+SCE->CE_PRODUTO+SCE->CE_FORNECE+SCE->CE_LOJA ==;
									    xFilial("SCE")+(cAliasSC8)->C8_NUM+(cAliasSC8)->C8_ITEM+(cAliasSC8)->C8_PRODUTO+(cAliasSC8)->C8_FORNECE+(cAliasSC8)->C8_LOJA
									    If SCE->CE_NUMPRO == (cAliasSC8)->C8_NUMPRO
											aAuditoria[nX][Len(aAuditoria[nX])][nY] := SCE->CE_QUANT
											aPlanilha[nX][Len(aPlanilha[nX])][1]    := "XX"//Marca fornecedor ganhador
											Exit
										Else
											aAuditoria[nX][Len(aAuditoria[nX])][nY] := IIF(SC8->(FieldPos("C8_QTDAUDI")) > 0 ,(cAliasSC8)->C8_QTDAUDI , 0 )
										Endif
									    SCE->(dbSkip())
									EndDo
								Else
									aAuditoria[nX][Len(aAuditoria[nX])][nY] := IIF(SC8->(FieldPos("C8_QTDAUDI")) > 0 ,(cAliasSC8)->C8_QTDAUDI , 0 )
								EndIf
							Case  aCabec[CAB_HFLD2][nY][2]=="CE_MOTIVO"
								aAuditoria[nX][Len(aAuditoria[nX])][nY] := (cAliasSC8)->C8_MOTIVO
							OtherWise
								aAuditoria[nX][Len(aAuditoria[nX])][nY] := CriaVar(aCabec[CAB_HFLD2][nY][2],.T.)

								//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
								//� Verifica se o campo pertence a tabela SCE  �
								//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
								If !Empty(SCE->(FieldPos(aCabec[CAB_HFLD2][nY][2])))
									dbSelectArea("SCE")
									dbSetOrder(1)
									//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
									//� Verifica se o fornecedor foi o vencedor    �
									//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
									If MsSeek(xFilial("SCE")+(cAliasSC8)->C8_NUM+(cAliasSC8)->C8_ITEM+(cAliasSC8)->C8_PRODUTO+;
										(cAliasSC8)->C8_FORNECE+(cAliasSC8)->C8_LOJA)

										//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
										//� Verifica a proposta correta    �
										//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
										While SCE->(!Eof()) .And. SCE->CE_FILIAL+SCE->CE_NUMCOT+SCE->CE_ITEMCOT+SCE->CE_PRODUTO+SCE->CE_FORNECE+SCE->CE_LOJA ==;
										    xFilial("SCE")+(cAliasSC8)->C8_NUM+(cAliasSC8)->C8_ITEM+(cAliasSC8)->C8_PRODUTO+(cAliasSC8)->C8_FORNECE+(cAliasSC8)->C8_LOJA
										    If SCE->CE_NUMPRO == (cAliasSC8)->C8_NUMPRO
												//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
												//� Preenche o campo da auditoria  �
												//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
												aAuditoria[nX][Len(aAuditoria[nX])][nY] := SCE->&(aCabec[CAB_HFLD2][nY][2])
												Exit
											Endif
										    SCE->(dbSkip())
										EndDo
									EndIf							
								EndIf
						EndCase
					Next nY
					aAuditoria[nX][Len(aAuditoria[nX])][ Len(aCabec[CAB_HFLD2])+1] := .F.

					aadd(aListBox[nX],{})
					nPlanScan := Len(aListBox[nX])
				Else
					If (nPlanFornec > 0 .And. nPlanLoja > 0 .And. nPlanNumPro > 0 .And. nPlanItem > 0)
						If (nPlanScan := aScan(aPlanilha[nX], {|z|	z[nPlanFornec] == (cAliasSC8)->C8_FORNECE .And. ;
							z[nPlanLoja] == (cAliasSC8)->C8_LOJA    .And. ;
							z[nPlanNumPro] == (cAliasSC8)->C8_NUMPRO  .And. ;
							z[nPlanItem] == (cAliasSC8)->C8_ITEM   })) > 0
							If nPlanTotal > 0
								aPlanilha[nX, nPlanScan, nPlanTotal] += nCusto
							EndIf
						Endif
					EndIf

					If (nSC8Scan := aScan(aCotacao[nX], {|z|	z[nSC8Fornec, 2] == (cAliasSC8)->C8_FORNECE .And. ;
						z[nSC8Loja  , 2] == (cAliasSC8)->C8_LOJA    .And. ;
						z[nSC8NumPro, 2] == (cAliasSC8)->C8_NUMPRO  .And. ;
						z[nSC8Item  , 2] == (cAliasSC8)->C8_ITEM   })) > 0
						
						aCotacao[nX, nSC8Scan, nSC8Quant, 2] += (cAliasSC8)->C8_QUANT
						aCotacao[nX, nSC8Scan, nSC8Total, 2] += (cAliasSC8)->C8_TOTAL
						aCotacao[nX, nSC8Scan, nSC8Preco, 2] := aCotacao[nX, nSC8Scan, nSC8Total, 2] / aCotacao[nX, nSC8Scan, nSC8Quant, 2]
						
						If nPlanPreco > 0
							aPlanilha[nX, nPlanScan,nPlanPreco] := aCotacao[nX, nSC8Scan, nSC8Preco, 2]						
						EndIf
					Endif

				Endif
				
				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//� Planilha de Fornecimento                                               �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
				aadd(aListBox[nX][nPlanScan],Array(nUsadoSC8)) 
				dbSelectArea(cAliasSC8)
				For nY := 1 To Len(aCabec[CAB_HFLD3])
					If aCampoSC8[nY][3] <> "M"
						aListBox[nX][nPlanScan][Len(aListBox[nX][nPlanScan])][nY] := TransForm(FieldGet(FieldPos(aCampoSC8[nY][1])),aCampoSC8[nY][2])
					Else
						SC8->(dbGoto( IIf(lQuery , (cAliasSC8)->SC8RECNO , (cAliasSC8)->(Recno())) ))
						aListBox[nX][nPlanScan][Len(aListBox[nX][nPlanScan])][nY] := &("SC8->"+aCampoSC8[nY][1])
					EndIf
				Next nY
				
				SCE->(dbSeek(xFilial("SCE") + (cAliasSC8)->(C8_NUM+C8_ITEM+C8_PRODUTO+C8_FORNECE+C8_LOJA)))

				//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
				//� Definicao da Estrutura do array aCotaGrade �
				//媚哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇
				//� 1 - C8_FORNECE                             �
				//� 2 - C8_LOJA                                �
				//� 3 - C8_NUMPRO                              �
				//� 4 - C8_ITEM                                �
				//� 5 - C8_PRODUTO (Familia)                   �
				//� 6 - Alimentado quando for produto de Grade �
				//� 6.1 - C8_PRODUTO                           �
				//� 6.2 - CE_QUANT                             �
				//� 6.3 - C8_DATPRF                            �
				//� 6.4 - C8_ITEMGRD                           �
				//� 6.5 - Recno SC8                            �
				//� 6.6 - C8_QUANT (Quantidade Original)       �
				//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
				If (nScan := aScan(aCotaGrade, {|z| z[1] + z[2] + z[3] + z[4] == ;
					(cAliasSC8)->C8_FORNECE + (cAliasSC8)->C8_LOJA + (cAliasSC8)->C8_NUMPRO + (cAliasSC8)->C8_ITEM})) == 0
					Aadd(aCotaGrade, {(cAliasSC8)->C8_FORNECE, (cAliasSC8)->C8_LOJA, (cAliasSC8)->C8_NUMPRO, (cAliasSC8)->C8_ITEM, RetCodProdFam((cAliasSC8)->C8_PRODUTO,!Empty((cAliasSC8)->C8_ITEMGRD)), {} })
					nScan := Len(aCotaGrade)
				Endif
				
				If (! Empty((cAliasSC8)->C8_ITEMGRD )) .And. nScan > 0
					Aadd(aCotaGrade[nScan, 6], {(cAliasSC8)->C8_PRODUTO,SCE->CE_QUANT, (cAliasSC8)->C8_DATPRF, (cAliasSC8)->C8_ITEMGRD, If(lQuery, (cAliasSC8)->SC8RECNO, (cAliasSC8)->(Recno())), (cAliasSC8)->C8_QUANT })
				Endif												
	
			EndIf
		//EndIf
	//EndIf

	dbSelectArea(cAliasSC8)
	dbSkip()

EndDo

lRetorno := Len(aPlanilha) > 0

If lQuery
	dbSelectArea(cAliasSC8)
	dbCloseArea()
	dbSelectArea("SC8")
EndIf

RestArea(aAreaSX3)
RestArea(aArea)

Return(lRetorno)