#Include "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"  
#INCLUDE "TBICONN.CH"  
#include "TBICODE.CH"      
#INCLUDE "TOPCONN.CH"

//--------------------------------------------------------------
/*/{Protheus.doc} AFATP05
@Atualiza��o Pre�os da Cota��o
@param xParam Parameter Description                             
@return xRet Return Description                                 
@author Jose Antonio (AMM)                                             
@since 13/12/2012                                                   
/*/                                                             
//--------------------------------------------------------------
*********************************************
User Function AFATP05(pCod,pFilCota)      
*********************************************
                  
Local oBitmap1
Local oBitmap2                                                                                                                         
Local oComboBo1     
Local oFont1 := TFont():New("Arial",,020,,.T.,,,,,.F.,.F.)
Local oFont2 := TFont():New("Arial",,018,,.T.,,,,,.F.,.F.)
Local oFont3 := TFont():New("Arial",,016,,.T.,,,,,.F.,.F.)
Local oFont4 := TFont():New("Arial",,016,,.F.,,,,,.F.,.F.)
Local oGet1                                                                                                                        
Local oGet2
Local dGet2 := Date()
Local oGet3
Local oGet5 
Local oGet6 
Local oGet7
Local oGet12
Local nGet7 := 0
Local oGet8
Local nGet8 := 0
Local oGroup1
Local oGroup2
Local oGroup3
Local oSay1
Local oSay10
Local oSay11
Local oSay2
Local oSay3
Local oSay4
Local oSay5
Local oSay6
Local oSay7
Local oSay8
Local oSay9
Local oSay12

Local oSButton1
Local oSButton2    
Local oSButton3    
Local aButtons     := {}
Local aRotina      :={}
Private oValMerc
Private nValMerc   := 0
Private oValFrete 
Private nValFrete  :=Criavar("C8_TOTFRE") 
Private oValDesc
Private nValDesc   :=Criavar("C8_ZTODESC")                   
Private oTotalCot
Private nTotalCot  :=Criavar("C8_TOTAL")        
Private cCondPgto  :=Criavar("C8_COND")
Private cDescPgto  := Criavar("E4_DESCRI")
Private oGet4     
Private cCotacao   :=pCod                                
Private cFilCota   :=pFilCota
Private aFornece   :={}
Private nComboBo1  :=1
Private oMSNewGeP05 
Private oMSNewPreco  
Private dDTENTRE   :=Date()
Private aPosObj	   := {}
Private aSizeAut   := MsAdvSize(,.F.)
Private aObjects   := {}
Private aInfo 	   := {}
Private nUsado     :=0   
Private cEmail     :=Criavar("C8_ZEMAIL") 
PRIVATE bZeraDesc  := {|| (nDesc1:=0),(nDesc2:=0),(nDesc3:=0)}
PRIVATE bFolderRefresh := {|| .T. }
PRIVATE bRefresh       := {|| .T. }

Private oTpFrete   
Private aTpFrete   := {"C=CIF","F=FOB",""}
Private cTpFrete   := ""
Private oTpDesc   
Private aTpDesc    := {"1=TOTAL","2=ITEM",""}
Private cTpDesc    := ""
Private aResolu    := getScreenRes()

Static oDlg    
       
AAdd( aObjects, { 000, 070, .T., .F. })
AAdd( aObjects, { 100, 100, .T., .T. })
aInfo  := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 2, 2 }
aPosObj:= MsObjSize( aInfo, aObjects )                                    

aSize := MsAdvSize(.F.)
 /*
 MsAdvSize (http://tdn.totvs.com/display/public/mp/MsAdvSize+-+Dimensionamento+de+Janelas)
 aSize[1] = 1 -> Linha inicial �rea trabalho.
 aSize[2] = 2 -> Coluna inicial �rea trabalho.
 aSize[3] = 3 -> Linha final �rea trabalho.
 aSize[4] = 4 -> Coluna final �rea trabalho.
 aSize[5] = 5 -> Coluna final dialog (janela).
 aSize[6] = 6 -> Linha final dialog (janela).
 aSize[7] = 7 -> Linha inicial dialog (janela).  */
 
SetKey(VK_F1, {|| fMSNewGe2()})     
                                  
If  Empty(pCod)
	Alert("Cota��o Numero n�o Existe" )
    Return()
Endif
FFornece() // Busca fornecedores.
                                        
  DEFINE MSDIALOG oDlg TITLE "Atualiza��o Pre�os da Cota��o" FROM aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5]  COLORS 0, 16777215 PIXEL

    @ 004, 004 SAY oSay1 PROMPT "Atualiza��o de Cota��es" SIZE 123, 010 OF oDlg FONT oFont1 COLORS 32768, 16777215 PIXEL
    IF(aResolu[1] == 1920 .AND. aResolu[2] == 1080) // MONITOR RESOLU��O 1920 x 1080
    @ 016, 002 GROUP oGroup1 TO aPosObj[1,3]+345, aPosObj[1,4] + 5 OF oDlg COLOR 0, 16777215 PIXEL
    Else
    @ 016, 002 GROUP oGroup1 TO aPosObj[1,3]+196, aPosObj[1,4] + 2 OF oDlg COLOR 0, 16777215 PIXEL
    Endif
    @ 021, 004 SAY oSay2 PROMPT "Informa��es" SIZE 099, 009 OF oDlg FONT oFont2 COLORS 128, 16777215 PIXEL
    @ 030, 004 GROUP oGroup2 TO 072, aPosObj[1,4] OF oDlg COLOR 0, 16777215 PIXEL
    @ 040, 007 SAY oSay3 PROMPT "Numero da Cota��o:" SIZE 081, 007 OF oDlg FONT oFont3 COLORS 0, 16777215 PIXEL 
    @ 040, 113 SAY oSay4 PROMPT "Data de Emiss�o:" SIZE 052, 007 OF oDlg FONT oFont3 COLORS 0, 16777215 PIXEL
    @ 040, 221 SAY oSay5 PROMPT "Fornecedor:" SIZE 040, 007 OF oDlg FONT oFont3 COLORS 0, 16777215 PIXEL
    @ 057, 007 SAY oSay6 PROMPT "Condi��o de Pagamento:" SIZE 090, 007 OF oDlg FONT oFont3 COLORS 0, 16777215 PIXEL
    @ 037, 070 MSGET oGet1 VAR cCotacao SIZE 042, 011 OF oDlg COLORS 0, 16777215 FONT oFont4 READONLY PIXEL WHEN .F.
    @ 037, 167 MSGET oGet2 VAR dGet2 SIZE 050, 011 OF oDlg COLORS 0, 16777215 FONT oFont4 PIXEL
    @ 037, 261 MSCOMBOBOX oComboBo1 VAR nComboBo1 ITEMS aFornece SIZE 170, 013 OF oDlg COLORS 0, 16777215 FONT oFont4 PIXEL ON CHANGE (nComboBo1:=oComboBo1:nAt,fMSNewGe1(cCotacao,aFornece[nComboBo1]) )

    @ 055, 084 MSGET oGet3 VAR cCondPgto SIZE 026, 011 OF oDlg COLORS 0, 16777215 FONT oFont4 F3 "SE4" Valid fCondPag() PIXEL
    @ 055, 118 MSGET oGet4 VAR cDescPgto SIZE 095, 011 OF oDlg COLORS 0, 16777215 FONT oFont4 PIXEL WHEN .F.
    @ 077, 004 SAY oSay7 PROMPT "Dados dos Itens" SIZE 081, 008 OF oDlg FONT oFont2 COLORS 128, 16777215 PIXEL
    
    IF (aResolu[1] == 1920 .AND. aResolu[2] == 1080) // MONITOR RESOLU��O 1920 x 1080
    
    @ 086, 004 GROUP oGroup3 TO 233, aPosObj[1,4] OF oDlg COLOR 0, 16777215 PIXEL
    
    @ 235, 004 SAY oSay7 PROMPT "Historico Pre�os" SIZE 081, 008 OF oDlg FONT oFont3 COLORS 128, 16777215 PIXEL
    @ 243, 004 GROUP oGroup3 TO 359, aPosObj[1,4] OF oDlg COLOR 0, 16777215 PIXEL 
    
    @ 370, 005 SAY oSay8 PROMPT "Valor da Mercadoria" SIZE 060, 007 OF oDlg FONT oFont4 COLORS 0, 16777215 PIXEL
    @ 370, 082 MSGET oValMerc VAR nValMerc SIZE 060, 011 PICTURE "@E 999,999,999.99" OF oDlg COLORS 0, 16777215 FONT oFont3 PIXEL WHEN .F.

    @ 382, 005 SAY oSay9 PROMPT "Valor do Frete" SIZE 050, 007 OF oDlg FONT oFont4 COLORS 0, 16777215 PIXEL
    @ 382, 082 MSGET oValFrete VAR nValFrete SIZE 060, 011 PICTURE "@E 999,999,999.99" OF oDlg COLORS 0, 16777215 FONT oFont3 PIXEL
    
    @ 382, 254 SAY oSay9 PROMPT "Tipo do Frete" SIZE 050, 007 OF oDlg FONT oFont4 COLORS 0, 16777215 PIXEL
    @ 382, 306 MSCOMBOBOX oTpFrete VAR cTpFrete ITEMS aTpFrete SIZE 060, 011 OF oDlg COLORS 0, 16777215 FONT oFont4 PIXEL 
    
    @ 394, 005 SAY oSay10 PROMPT "Valor dos Descontos" SIZE 060, 007 OF oDlg FONT oFont4 COLORS 0, 16777215 PIXEL
    @ 396, 082 MSCOMBOBOX oTpDesc VAR cTpDesc ITEMS aTpDesc SIZE 060, 011 OF oDlg COLORS 0, 16777215 FONT oFont4 PIXEL
    @ 395, 142 MSGET oValDesc VAR nValDesc SIZE 060, 009 PICTURE "@E 999,999,999.99" Valid IIF(cTpDesc <> '1',fRateiaDesc(nValDEsc),) WHEN IIF(cTpDesc == '1',.T.,.F.) OF oDlg COLORS 0, 16777215 FONT oFont3 PIXEL
    
    @ 394, 254 SAY oSay11 PROMPT "Total da Cota��o" SIZE 050, 007 OF oDlg FONT oFont4 COLORS 0, 16777215 PIXEL
    @ 394, 306 MSGET oTotalCot VAR nTotalCot SIZE 060, 011 PICTURE "@E 999,999,999.99" OF oDlg COLORS 0, 16777215 FONT oFont3 PIXEL WHEN .F.
    
 	fMSNewGe1(cCotacao,aFornece[nComboBo1])

	DEFINE SBUTTON oSButton1 FROM 394, 406 TYPE 01 ACTION fConfirma() OF oDlg ENABLE 
    oSButton1:SetCSS(	"QPushButton{ background-color: #009ACD; color: #E0FFFF; font-size: 12px; border: 1px solid #585858; } " ) 
    DEFINE SBUTTON oSButton2 FROM 394, 446 TYPE 02 ACTION oDlg:End() OF oDlg ENABLE  
    oSButton2:SetCSS(	"QPushButton{ background-color: #009ACD; color: #E0FFFF; font-size: 12px; border: 1px solid #585858; } " ) 
    
    Else
    
    @ 086, 004 GROUP oGroup3 TO 203, aPosObj[1,4] OF oDlg COLOR 0, 16777215 PIXEL
    
    @ 205, 004 SAY oSay7 PROMPT "Historico Pre�os" SIZE 081, 008 OF oDlg FONT oFont3 COLORS 128, 16777215 PIXEL
    @ 213, 004 GROUP oGroup3 TO 259, aPosObj[1,4] OF oDlg COLOR 0, 16777215 PIXEL
    
    @ 260, 005 SAY oSay8 PROMPT "Valor da Mercadoria" SIZE 060, 007 OF oDlg FONT oFont4 COLORS 0, 16777215 PIXEL
    @ 260, 082 MSGET oValMerc VAR nValMerc SIZE 060, 011 PICTURE "@E 999,999,999.99" OF oDlg COLORS 0, 16777215 FONT oFont3 PIXEL WHEN .F.

    @ 272, 005 SAY oSay9 PROMPT "Valor do Frete" SIZE 050, 007 OF oDlg FONT oFont4 COLORS 0, 16777215 PIXEL
    @ 272, 082 MSGET oValFrete VAR nValFrete SIZE 060, 011 PICTURE "@E 999,999,999.99" OF oDlg COLORS 0, 16777215 FONT oFont3 PIXEL
    
    @ 272, 254 SAY oSay9 PROMPT "Tipo do Frete" SIZE 050, 007 OF oDlg FONT oFont4 COLORS 0, 16777215 PIXEL
    @ 272, 306 MSCOMBOBOX oTpFrete VAR cTpFrete ITEMS aTpFrete SIZE 060, 011 OF oDlg COLORS 0, 16777215 FONT oFont4 PIXEL 
    
    @ 284, 005 SAY oSay10 PROMPT "Valor dos Descontos" SIZE 060, 007 OF oDlg FONT oFont4 COLORS 0, 16777215 PIXEL
    @ 286, 082 MSCOMBOBOX oTpDesc VAR cTpDesc ITEMS aTpDesc SIZE 060, 011 OF oDlg COLORS 0, 16777215 FONT oFont4 PIXEL
    @ 285, 142 MSGET oValDesc VAR nValDesc SIZE 060, 009 PICTURE "@E 999,999,999.99" Valid IIF(cTpDesc <> '1',fRateiaDesc(nValDEsc),) WHEN IIF(cTpDesc == '1',.T.,.F.)  OF oDlg COLORS 0, 16777215 FONT oFont3 PIXEL
    
    @ 284, 254 SAY oSay11 PROMPT "Total da Cota��o" SIZE 050, 007 OF oDlg FONT oFont4 COLORS 0, 16777215 PIXEL
    @ 284, 306 MSGET oTotalCot VAR nTotalCot SIZE 060, 011 PICTURE "@E 999,999,999.99" OF oDlg COLORS 0, 16777215 FONT oFont3 PIXEL WHEN .F.
    
 	fMSNewGe1(cCotacao,aFornece[nComboBo1])

	DEFINE SBUTTON oSButton1 FROM 284, 406 TYPE 01 ACTION fConfirma() OF oDlg ENABLE 
    oSButton1:SetCSS(	"QPushButton{ background-color: #009ACD; color: #E0FFFF; font-size: 12px; border: 1px solid #585858; } " ) 
    DEFINE SBUTTON oSButton2 FROM 284, 446 TYPE 02 ACTION oDlg:End() OF oDlg ENABLE  
    oSButton2:SetCSS(	"QPushButton{ background-color: #009ACD; color: #E0FFFF; font-size: 12px; border: 1px solid #585858; } " ) 
    Endif
    
  ACTIVATE MSDIALOG oDlg CENTERED

Return
                 
//------------------------------------------------ 
Static Function fCancelar()
// Funcao para mostrar os historico dos produtos 
// Cota��o agrupado por produto e menor preco
//------------------------------------------------ 
/*
 Fun�ao de validar a linha ok
*/
oDlg:End()
               
Return()     

/*
Confirma grava�ao
*/

Static Function fConfirma()

Local lAtuSC8 := .F.

If Empty(cCondPgto)
	Aviso("Aten��o","Condi��o de pagamento n�o informada !",{"Fechar"},2) 
	Return
Endif 

MsAguarde( {|lEnd|lAtuSC8 := FGravaSC8()},"Aguarde","Gravando Registros...",.T.)

IF nComboBo1 < Len(aFornece) .And. lAtuSC8    
	If MsgYesNo( "Atualizar mais fornecedor?" ) 
    	nComboBo1+=1                           
		fMSNewGe1(cCotacao,aFornece[nComboBo1])  
		Return
	else
		oDlg:End()
	Endif
else
	Aviso("Aten��o","Cota��o atualizada com sucesso !!!",{"Fechar"},2) 
	oDlg:End()	
Endif    

Return 
                                                   

//------------------------------------------------ 
Static Function fMSNewGe1()
//------------------------------------------------ 
Local nX
Local aHeaderEx  := {}
Local aColsEx    := {}
Local aHeaderHs  := {}
Local aColsHs    := {}
Local aFieldFill := {}
Local aAlterFields := {"C8_ZPRDSUB","C8_PRECO","C8_QUANT","C8_ZDENTR","C8_OBS","C8_ALIIPI","C8_PICM","C8_DESC","C8_VLDESC"}
Local aFields      := {"C8_ITEM","C8_ZDESCRI","B1_ZREF1","C8_UM","C8_ZPRDSUB","C8_QUANT","C8_PRECO","C8_TOTAL","C8_ZAPLIC","C8_ZDENTR","C8_NUMSC","C8_ZOBSADI","C8_OBS","C8_ALIIPI","C8_PICM","C8_DESC","C8_VLDESC","C8_PRODUTO","C1_ZTIPOPR",;
"C8_ZGANHAD","C8_DATPRF"}
Local nUsado       := Len(aFields)
Local nPostTpPr	   := aScan(aFields,{|x| AllTrim(x) == "C1_ZTIPOPR"})
Local nPostZRef	   := aScan(aFields,{|x| AllTrim(x) == "B1_ZREF1"})  

  
Static oMSNewGe1
	// Define field properties
	DbSelectArea("SX3")
  	SX3->(DbSetOrder(2))
  	For nX := 1 to Len(aFields)
    	If SX3->(DbSeek(aFields[nX]))
      		Aadd(aHeaderEx, {IIF(AllTrim(X3Titulo()) == 'Item Cotacao','Item',AllTrim(X3Titulo())),SX3->X3_CAMPO,SX3->X3_PICTURE,;
      		           IIF(AllTrim(X3Titulo()) == 'Desc Produto',37,IIF(AllTrim(X3Titulo()) == 'Cod.Original',15,SX3->X3_TAMANHO)),;
      		           SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,;
      		           SX3->X3_CBOX,SX3->X3_RELACAO,SX3->X3_WHEN,SX3->X3_VISUAL,SX3->X3_VLDUSER,SX3->X3_PICTVAR,SX3->X3_OBRIGAT})            
	    Endif
  	Next nX

  	// Define field values
  	nValdesc  := 0
  	nValFrete := 0       
  	cTpFrete  := ""
  	
  	dbSelectArea("SC8")
  	dbSetOrder(1)          
  	dbSeek(cFilCota+cCotacao+Left(aFornece[nComboBo1],8),.T.)
//  	dbSeek(xFilial("SC8")+cCotacao+Left(aFornece[nComboBo1],8),.T.) //AA
  	While !Eof() .And. SC8->C8_FILIAL+SC8->C8_NUM   == cFilCota+cCotacao .And. ; 
                       SC8->C8_FORNECE+SC8->C8_LOJA == Left(aFornece[nComboBo1],8)   
                     
	  	if !Empty(SC8->C8_NUMPED)
	  	 if(Funname() <> "TPCOM004") // ROTINA DE LIBERA��O DE PEDIDO DE COMPRAS
		   dbSelectArea("SC8")
		   dbSkip()                                          
		   Loop
		  endif 
	  	endif

		aadd(aColsEx,Array(Len(aHeaderEx)+2))
		  
		cNome:=Left(Posicione("SA2",1,xFilial("SA2")+SC8->C8_FORNECE+SC8->C8_LOJA,"A2_NOME"),30)                                                                                                        
		nPos:=aScan( aFornece, {|x| Alltrim(x) == Alltrim(SC8->C8_FORNECE+SC8->C8_LOJA+"-"+cNome)  } )
		
		cCondPgto := SC8->C8_COND     
        If !Empty(SC8->C8_ZEMAIL)
			cEmail:=SC8->C8_ZEMAIL
		Else
			cEmail:=Left(Posicione("SA2",1,xFilial("SA2")+SC8->C8_FORNECE+SC8->C8_LOJA,"A2_EMAIL"),30)
		Endif	    
		
		cDescPgto := Posicione("SE4",1,xFilial("SE4")+SC8->C8_COND,"E4_DESCRI")
		//nValFrete += SC8->C8_VALFRE  
		nValdesc  += SC8->C8_VLDESC
		
	  	nValFrete += SC8->C8_VALFRE       
		cTpFrete  := SC8->C8_TPFRETE
		
		If Empty(SC8->C8_DESC)
		    nTotal   := (SC8->C8_PRECO * SC8->C8_QUANT)
			nDesc    := nTotal - (nTotal * 1-(nTotal * SC8->C8_DESC/100) )
			nValdesc += nDesc         
		Endif	 
		  
		If Empty(nPos)
			aadd(aFornece,Alltrim(SC8->C8_FORNECE+SC8->C8_LOJA+"-"+cNome) )
 		Endif
		For nX := 1 To Len(aHeaderEx)
			if !Alltrim(aHeaderEx[nx,2]) $ "C1_ZTIPOPR)"
		  		aColsEx[Len(aColsEx)][nX] :=  SC8->(FieldGet(FieldPos(aHeaderEx[nx,2]) ))
		 	endif
		Next nX                          
  		aColsEx[Len(aColsEx)][nPostTpPr] := Posicione("SC1",1,SC8->C8_FILIAL+SC8->C8_NUMSC+SC8->C8_ITEMSC,"C1_ZTIPOPR")
  		
  		if aColsEx[Len(aColsEx)][nPostTpPr] == "S"
  			aAlterFields := {"C8_ZPRDSUB","C8_PRECO","C8_QUANT","C8_ZDENTR","C8_OBS","C8_ALIIPI","C8_PICM","C8_DESC","C8_VLDESC"}
  		else
  			aAlterFields := {"C8_ZPRDSUB","C8_PRECO","C8_QUANT","C8_ZDENTR","C8_OBS","C8_ALIIPI","C8_PICM","C8_DESC","C8_VLDESC"}
  		endif
  		
  		aColsEx[Len(aColsEx)][nPostZRef] := Posicione("SB1",1,xFilial("SB1")+SC8->C8_PRODUTO,"B1_ZREF1")
	  	aColsEx[Len(aColsEx)][Len(aHeaderEx)+1] := SC8->(Recno())	
		aColsEx[Len(aColsEx)][Len(aHeaderEx)+2] := .F.	
		dbSelectArea("SC8")
		dbSkip()
  EndDo    
  
 IF(aResolu[1] == 1920 .AND. aResolu[2] == 1080) // MONITOR RESOLU��O 1920 x 1080
  
  oMSNewGeP05 := MsNewGetDados():New( 090, 006, aPosObj[1,3]+130,aPosObj[1,4]-3, GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "+C8_ITEM", aAlterFields,, Len(aColsEx), "AllwaysTrue", "", "AllwaysTrue", oDlg, aHeaderEx, aColsEx)
  oMSNewGeP05:oBrowse:BSETGET := {||nTotalCot :=U_FSATUCAB(oMSNewGeP05:aCols[oMSNewGeP05:nAt][7]),oTotalCot:Refresh()}//atualiza saldo no cabe�alho de acordo com o saldo no acols.
  //oMSNewGeP05:oBrowse:bLDblClick := {|| fMSNewGe2(),oMSNewGeP05:oBrowse:DrawSelect()}

//oMSNewGeP05:aCols[oMSNewGeP05:oBrowse:nAt,16]
  
 ELSE
 
  oMSNewGeP05 := MsNewGetDados():New( 090, 006, aPosObj[1,3]+100,aPosObj[1,4]-3, GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "+C8_ITEM", aAlterFields,, Len(aColsEx), "AllwaysTrue", "", "AllwaysTrue", oDlg, aHeaderEx, aColsEx)
  oMSNewGeP05:oBrowse:BSETGET := {||nTotalCot :=U_FSATUCAB(oMSNewGeP05:aCols[oMSNewGeP05:nAt][7]),oTotalCot:Refresh()}//atualiza saldo no cabe�alho de acordo com o saldo no acols.
  //oMSNewGeP05:oBrowse:bLDblClick := {|| fMSNewGe2(),oMSNewGeP05:oBrowse:DrawSelect()}
 ENDIF
  fMSNewGe2()
  oMSNewGeP05:oBrowse:Refresh()

Return

************************************     
User Function FSATUCAB(pValor)  
************************************   

Local nAliqIpi := 0
Local nValIpi  := 0
nValMerc  := 0
//nValFrete := 0
If (cTpDesc <> '1') 
nValDesc := 0
Endif


For nI := 1 To Len(oMSNewGeP05:aCols)                                
	If !oMSNewGeP05:aCols[oMSNewGeP05:nAt,Len(oMSNewGeP05:aCols[oMSNewGeP05:nAt])] 
      	   
	   nAliqIpi := oMsNewGeP05:aCols[ni][14] 
	   nValIpi  := nAliqIpi / 100 * (oMSNewGeP05:aCols[ni][6] * oMSNewGeP05:aCols[ni][7])
	   
	   nValMerc := nValMerc + ( oMSNewGeP05:aCols[ni][6] * oMSNewGeP05:aCols[ni][7] ) + nValIpi // - oMSNewGeP05:aCols[ni][12]
	 If (cTpDesc <> '1')	      
	   nValDesc := nValDesc + (((oMSNewGeP05:aCols[ni][8] + nValIpi) * oMSNewGeP05:aCols[ni][16])/100) //oMSNewGeP05:aCols[ni][17]  
	 Endif	      
	Endif
		
Next nI

//nValMerc:= nTotal 	
nGeral  := nValMerc + nValFrete - nValDesc  

oValMerc:Refresh()
oTotalCot:Refresh()
oValFrete:Refresh() 
oValDesc:Refresh()      

Return(nGeral) 
//------------------------------------------------ 
//* Grava na tabela SC8 cota�ao   
//------------------------------------------------ 
Static Function FGravaSC8()
Local x1:=0
Local aWBrowGru := {}  
Local aAuxGru   := {}    
Local lRet      :=.F.
Local nConReg   := 0  
Local cUsrCot   :=UsrRetName(RetCodUsr())
Local aReg	    :={}                          
Local cCodUser  :=RetCodUsr()
Local nXXTotQt  := 0
     
aHeader:=Aclone(oMSNewGeP05:aHeader)

For nX := 1 To Len(oMSNewGeP05:aCols)
	If !oMSNewGeP05:aCols[oMSNewGeP05:nAt,Len(oMSNewGeP05:aCols[oMSNewGeP05:nAt])] 
		
		//if oMSNewGeP05:aCols[nx,GDFieldPos("C8_PRECO")] == 0
		//	Aviso("Aten��o","O pre�o unit�rio n�o pode ser igual a 0 !",{"Fechar"},2) 
		//	Return .F.
		//Endif 
		
		//if oMSNewGeP05:aCols[nx,GDFieldPos("C8_ZDENTR")] == cTod("//")
		//	Aviso("Aten��o","Data de entrega n�o pode ficar em branco !",{"Fechar"},2) 
		//	Return .F.
		//Endif 
		
		nXXTotQt := nXXTotQt + oMSNewGeP05:aCols[nx,GDFieldPos("C8_TOTAL")]
		
						
	endif	
Next 


	Begin Transaction   
		For nX := 1 To Len(oMSNewGeP05:aCols)
			If !oMSNewGeP05:aCols[oMSNewGeP05:nAt,Len(oMSNewGeP05:aCols[oMSNewGeP05:nAt])] 
				dbSelectArea("SC8") 
				dbGoto(oMSNewGeP05:aCols[nX,Len(oMSNewGeP05:aCols[nX])-1])	 
				RecLock("SC8", .F.)
	            	SC8->C8_PRECO   := oMSNewGeP05:aCols[nx,GDFieldPos("C8_PRECO")]
	            	SC8->C8_QUANT   := oMSNewGeP05:aCols[nx,GDFieldPos("C8_QUANT")]
	            	SC8->C8_TOTAL   := oMSNewGeP05:aCols[nx,GDFieldPos("C8_TOTAL")] 
	            	SC8->C8_ZGANHAD := oMSNewGeP05:aCols[nx,GDFieldPos("C8_ZGANHAD")] 
	            	SC8->C8_ALIIPI  := oMSNewGeP05:aCols[nx,GDFieldPos("C8_ALIIPI")] 
	            	SC8->C8_PICM    := oMSNewGeP05:aCols[nx,GDFieldPos("C8_PICM")] 
	            	SC8->C8_DESC    := oMSNewGeP05:aCols[nx,GDFieldPos("C8_DESC")] 
	            	SC8->C8_VLDESC  := oMSNewGeP05:aCols[nx,GDFieldPos("C8_VLDESC")]
	            	SC8->C8_NUMSC   := oMSNewGeP05:aCols[nx,GDFieldPos("C8_NUMSC")] 
	            	SC8->C8_ZDENTR  := oMSNewGeP05:aCols[nx,GDFieldPos("C8_ZDENTR")]
	            	SC8->C8_DATPRF  := oMSNewGeP05:aCols[nx,GDFieldPos("C8_DATPRF")]
	            	SC8->C8_OBS     := oMSNewGeP05:aCols[nx,GDFieldPos("C8_OBS")]
	            	SC8->C8_EMISSAO := DATE()
	            	SC8->C8_ZHORA   := TIME()
	            	SC8->C8_ZTODESC := nValdesc
	            	
	            	/*
	            	Conta de rateio como � feita no sistema
	            	*/	            	
		    		SC8->C8_VALFRE  := (nValFrete/100) * (( SC8->C8_TOTAL * 100 ) / nXXTotQt)
		    		SC8->C8_TPFRETE := cTpFrete
		    		
		    		SC8->C8_COND    := cCondPgto    
		    		SC8->C8_ZEMAIL  := cEmail
		    		SC8->C8_ZPRDSUB := oMSNewGeP05:aCols[nx,GDFieldPos("C8_ZPRDSUB")]     
				MsUnLock()  
			  	//FGravaSZ1(nReg,aReg)
			Endif	
			dbSelectArea("SZ2") 
			cNumero := GetSxENum("SZ2","Z2_NUMERO") 
			ConfirmSX8()
  
			If RecLock("SZ2", .T.) 
				SZ2->Z2_FILIAL := SC8->C8_FILIAL
   		    	SZ2->Z2_NUMERO   :=cNumero
			    SZ2->Z2_CODIGO   := "003" 
			   	SZ2->Z2_NUMSC    := SC8->C8_NUMSC
			   	SZ2->Z2_NUMCOT   := SC8->C8_NUM
			   	SZ2->Z2_PRODUTO  := SC8->C8_PRODUTO
			   	SZ2->Z2_ITEMSC   := SC8->C8_ITEMSC
			   	SZ2->Z2_CODUSR   := cCodUser
			   	SZ2->Z2_NOMEUSR  := cUsrCot
			  	SZ2->Z2_MOTIVO   := "ATUALIZA��O DE PRE�O"   
			   	SZ2->Z2_DATA     := DATE()
			   	SZ2->Z2_HORA     := TIME()
			   	SZ2->Z2_MOTIVO   := "ATUALIZA COTA��O"
			   	SZ2->Z2_EMAIL1   :=""
			   	SZ2->Z2_EMAIL2   :=""
			   	SZ2->Z2_EMAIL3   :=""
			   	SZ2->Z2_EMAIL4   :=""
			   	SZ2->Z2_EMAIL5   :=""
				MsUnLock()  
		Endif	  

		Next
	
	End Transaction

Return .T.  
//------------------------------------------------ 
//* Verificar fornecedores
//------------------------------------------------ 
Static Function FFornece()
  dbSelectArea("SC8")
  dbSetOrder(1)
  dbSeek(cFilCota+cCotacao,.T.)
  While !Eof() .And. SC8->C8_FILIAL+SC8->C8_NUM == cFilCota+cCotacao                     
		cNome:=Left(Posicione("SA2",1,xFilial("SA2")+SC8->C8_FORNECE+SC8->C8_LOJA,"A2_NOME"),30)		                                                                                                        
		nPos:=aScan( aFornece, {|x| Alltrim(x) == Alltrim(SC8->C8_FORNECE+SC8->C8_LOJA+"-"+cNome)  } )
		If Empty(nPos) .And. (Empty(SC8->C8_NUMPED) .OR. (Funname() == "TPCOM004")) 
			aadd(aFornece,SC8->C8_FORNECE+SC8->C8_LOJA+"-"+cNome )
		Endif       
		nValFrete +=SC8->C8_VALFRE
		nValDesc  :=SC8->C8_ZTODESC                   
		nTotalCot +=SC8->C8_TOTAL        
		cCondPgto :=SC8->C8_COND
		nValMerc  +=SC8->C8_TOTAL 
        If !Empty(SC8->C8_ZEMAIL)
			cEmail:=SC8->C8_ZEMAIL
		Else
			cEmail:=Left(Posicione("SA2",1,xFilial("SA2")+SC8->C8_FORNECE+SC8->C8_LOJA,"A2_EMAIL"),30)
		Endif	
		dbSelectArea("SC8")		
  SC8->(dbSkip())  
  EndDo  
           
 nTotalCot +=(nValFrete - nValDesc)       

Return()       
//------------------------------------------------ 
//* Verificar fornecedores
//------------------------------------------------ 

User Function FAT5LINOK()
Local lRet	 	:= .T.
Local nTot 	 	:= 0
Local nX   	 	:= 0
Local nPosPro	:= aScan(oMSNewGeP05:aHeader,{|x| AllTrim(x[2])=="C8_PRODUTO"})
Local nPosQtd	:= aScan(oMSNewGeP05:aHeader,{|x| AllTrim(x[2])=="C8_QUANT"})
Local nPosVal	:= aScan(oMSNewGeP05:aHeader,{|x| AllTrim(x[2])=="C8_PRECO"})
Local nPosDesc1	:= aScan(oMSNewGeP05:aHeader,{|x| AllTrim(x[2])=="C8_DESC"})
Local nPosDesc2	:= aScan(oMSNewGeP05:aHeader,{|x| AllTrim(x[2])=="C8_VLDESC"})
Local nPosIpi 	:= aScan(oMSNewGeP05:aHeader,{|x| AllTrim(x[2])=="C8_ALIIPI"})

IF !oMSNewGeP05:aCols[oMSNewGeP05:nAt,nUsado]
	IF lRet
		For nx:= 1 to nUsado-1		
			nTot += oMSNewGeP05:aCols[oMSNewGeP05:nAt ,nX]
		Next nX
	Endif
Endif

Return lRet

/*
Cria uma tela de consulta das ultimas compras, cotacoes ,
consumos de um determinado produto.                       
*/
Static Function fComView(cProduto)

Local aArea		:= GetArea()
Local aAreaSX3	:= SX3->(GetArea())
Local aAreaSB1	:= SB1->(GetArea())
Local aCpos		:= {}
Local nCntFor
Local nRecSB1
Local oBold
Local oDlg1
Local lContCT  := .T.
Local lContPC  := .T.
Local lContNF  := .T.
Local cProduto  := oMSNewGeP05:aCols[oMSNewGeP05:nAt][14]   

Private aTELA[0][0],aGETS[0]
Private lRefresh	:= .T.
Private Inclui		:= .F.
Private Altera		:= .F.
Private aViewSC8
Private aViewSC7
Private aViewNF
Private aRecSD1
Private aRecSD1



//������������������������������������������������������������������������Ŀ
//� Posiciona o cadastro de produtos                                       �
//��������������������������������������������������������������������������
dbSelectArea('SB1')
dbSetOrder(1)
If MsSeek(xFilial("SB1")+cProduto)
    nRecSB1:=Recno()
	dbSelectArea("SX3")
	dbSetOrder(1)
	If MsSeek("SB1")
		While ( !Eof() .And. SX3->X3_ARQUIVO == "SB1" )
			If X3USO(X3_USADO) .And. cNivel >= X3_NIVEL .And. !(AllTrim(X3_CAMPO)$"B1_COD/B1_DESC")
				aAdd(aCpos,X3_CAMPO)
			EndIf
			dbSkip()
		Enddo
		RegToMemory("SB1", .F., .F. )
		DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD
		DEFINE MSDIALOG oDlg1 FROM 0,0 TO 340,600 TITLE OemToAnsi('Historico de Compras') Of oMainWnd PIXEL      //   'Historico de Compras'
		EnChoice("SB1", nRecSB1, 2, , , , aCpos ,{20,2,150,298} , ,3 )   
	  	@ 157 ,10  BUTTON "Ultimos Pedidos" SIZE 45 ,10  FONT oDlg1:oFont ACTION MaComViewPC(SB1->B1_COD,lContPC)  OF oDlg1 PIXEL  //"Ultimos Pedidos"
		@ 157 ,56  BUTTON "Ultimas Cotacoes" SIZE 45 ,10  FONT oDlg1:oFont ACTION FMaComViewCT(SB1->B1_COD)  OF oDlg1 PIXEL  //"Ultimas Cotacoes"
	 	@ 157 ,102 BUTTON "Consumo" SIZE 45 ,10  FONT oDlg1:oFont ACTION MaComViewSm(SB1->B1_COD)  OF oDlg1 PIXEL  //"Consumo"
		@ 157 ,148 BUTTON "Ultimas N.Fiscais" SIZE 45 ,10  FONT oDlg1:oFont ACTION MaComViewNF(SB1->B1_COD,lContNF)  OF oDlg1 PIXEL  //"Ultimas N.Fiscais"
		@ 157 ,194 BUTTON "Consulta Estoques" SIZE 49 ,10  FONT oDlg1:oFont ACTION MaViewSB2(SB1->B1_COD)  OF oDlg1 PIXEL  //"Consulta Estoques"
		@ 157 ,244 BUTTON "Sair" SIZE 45 ,10  FONT oDlg1:oFont ACTION (oDlg1:End())  OF oDlg1 PIXEL  //"Sair"
		@ 4  ,10   SAY Alltrim(cProduto)+ " - "+SB1->B1_DESC Of oDlg1 PIXEL SIZE 245 ,9 FONT oBold
		@ 13, 4 To 14,302 Label "" of oDlg1 PIXEL  
		ACTIVATE MSDIALOG oDlg1 CENTERED
	EndIf
Endif

RestArea(aAreaSX3)
RestArea(aAreaSB1)
RestArea(aArea)
Return Nil

/*   
 Consulta de contacao de precos
*/

Static Function fMaComViewCT(cProduto)

Local aAliasOLD := GetArea()
Local cAliasQry := GetNextAlias() 
Local aRecSC8	:= {}
Local aNew      := {} 
//Local aFields   := {"C8_NUM","C8_ITEM","C8_FORNECE","C8_LOJA","A2_NOME","C8_QUANT","C8_PRECO","C8_TOTAL","C8_COND","E4_DESCRI","C8_ZDENTR","C8_EMISSAO","C8_VALFRE","C8_ALIIPI","C8_PICM","C8_DESC","C8_VLDESC","C8_ZTODESC","C8_ZMARCA","C8_ZGANHAD"}
Local aFields   := {"C8_NUM","C8_ITEM","C8_FORNECE","C8_LOJA","A2_NOME","C8_QUANT","C8_PRECO","C8_TOTAL","C8_COND","E4_DESCRI","C8_ZDENTR","C8_EMISSAO","C8_VALFRE","C8_ALIIPI","C8_PICM","C8_DESC","C8_VLDESC","C8_ZTODESC","C8_ZMARCA"}
Local aHeadCpos	:= {}
Local aFieldName:= {}           
Local nCont     :=0   
Local oDlg                                     
Local oBold
  // Define field properties
  DbSelectArea("SX3")
  SX3->(DbSetOrder(2))
  For nX := 1 to Len(aFields)
    If SX3->(DbSeek(aFields[nX]))
      Aadd(aHeadCpos, {AllTrim(X3Titulo())})
    Endif
  Next nX 
  For nI := 1 to len(aFields)
	  aAdd(aFieldName,aHeadCpos[nI,1])
  Next nI
  
dbSelectArea('SB1')
dbSetOrder(1)                   
If MsSeek(xFilial()+cProduto)
	cDescProd := SB1->B1_DESC
	aViewSC8 := {}
	BeginSql Alias cAliasQry
		SELECT C8_NUM,C8_ITEM,C8_QUANT,C8_FORNECE,C8_LOJA,C8_PRECO,C8_TOTAL,C8_COND,C8_EMISSAO,C8_ZDENTR,C8_ALIIPI,
		       C8_PICM,C8_VALFRE,C8_DESC,C8_VLDESC,C8_ZTODESC,C8_PRAZO,C8_ZMARCA,C8_ZOBSADI,A2_NOME,E4_DESCRI,C8_ZPRDSUB 
		FROM %table:SC8% SC8 
		INNER JOIN %table:SA2% SA2 ON SC8.C8_FORNECE = SA2.A2_COD AND SC8.C8_LOJA = SA2.A2_LOJA AND SA2.%notDel%   
		LEFT  JOIN %table:SE4% SE4 ON( SC8.C8_COND = SE4.E4_CODIGO AND SE4.%notDel%)
		WHERE SC8.%notDel% 	AND    
		SC8.C8_PRODUTO = %Exp:cProduto%          
 	    ORDER BY C8_EMISSAO DESC
 	EndSql            
	(cAliasQry)->(dbGotop())
	While (cAliasQry)->( !Eof() ) 
	        nCont++
			aAdd(aViewSC8,{(cAliasQry)->C8_NUM,; 
				(cAliasQry)->C8_ITEM,;
				(cAliasQry)->C8_FORNECE,;
				(cAliasQry)->C8_LOJA,;
				(cAliasQry)->A2_NOME,;
				TransForm((cAliasQry)->C8_QUANT,PesqPict("SC8","C8_QUANT")),;
				TransForm((cAliasQry)->C8_PRECO,PesqPict("SC8","C8_PRECO")),;
				TransForm((cAliasQry)->C8_TOTAL,PesqPict("SC8","C8_TOTAL")),;
				(cAliasQry)->C8_COND,;
				(cAliasQry)->E4_DESCRI,;
				(cAliasQry)->C8_ZDENTR,;
				Right((cAliasQry)->C8_EMISSAO,2)+'/'+SubStr((cAliasQry)->C8_EMISSAO,5,2)+'/'+Left((cAliasQry)->C8_EMISSAO,4),;
				TransForm((cAliasQry)->C8_VALFRE,PesqPict("SC8","C8_VALFRE")),;
				TransForm((cAliasQry)->C8_ALIIPI,PesqPict("SC8","C8_ALIIPI")+" %"),;
				TransForm((cAliasQry)->C8_PICM,PesqPict("SC8","C8_PICM")+" %"),;
				TransForm((cAliasQry)->C8_DESC,PesqPict("SC8","C8_DESC")+" %"),;
				TransForm((cAliasQry)->C8_VLDESC,PesqPict("SC8","C8_VLDESC")),;
				TransForm((cAliasQry)->C8_ZTODESC,PesqPict("SC8","C8_ZTODESC")),;
				(cAliasQry)->C8_ZMARCA,;//(cAliasQry)->C8_ZGANHAD})
				""})
				dbSkip()
				If nCont> 200
				   exit
				Endif   					                        
	EndDo
	(cAliasQry)->(dbCloseArea())
	If !Empty(aViewSC8)
			DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD
			DEFINE MSDIALOG oDlg FROM 0,0  TO 340,600 TITLE "Historico de compras - Ultimas Cota��es" Of oMainWnd PIXEL //
			@ 13, 4 To 14,302 Label "" of oDlg PIXEL       
			oListBox := TWBrowse():New( 20,2,298,130,,aFieldName,,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,) 
			oListBox:SetArray(aViewSC8)
			oListBox:bLine := { || aViewSC8[oListBox:nAT]}
			@ 4  ,10   SAY Alltrim(cProduto)+ " - "+cDescProd Of oDlg PIXEL SIZE 245 ,9 FONT oBold
			@ 157 ,244  BUTTON "Voltar" SIZE 45 ,10  FONT oDlg:oFont ACTION (oDlg:End())  OF oDlg PIXEL  //
			ACTIVATE MSDIALOG oDlg CENTERED
	Else
			Aviso("Atencao","Nao existem cotacoes colocadas para este produto.",{"Voltar"},2) 
	EndIf	
Endif
RestArea(aAliasOLD) 
Return Nil   

*************************************
Static Function fCondPag
*************************************
*
*
dbSelectArea("SE4")
dbSetOrder(1)
dbSeek(xFilial("SE4")+cCondPgto)

cDescPgto := Alltrim(SE4->E4_DESCRI)
oGet4:Refresh()

return .T.


Static Function fRateiaDesc(nValDesc)
*************************************
* rateia desconto total nos itens
*************************************
Local nPosDesc2	:= aScan(oMSNewGeP05:aHeader,{|x| AllTrim(x[2])=="C8_VLDESC"})
Local nPosQtd	:= aScan(oMSNewGeP05:aHeader,{|x| AllTrim(x[2])=="C8_QUANT"})
Local nPosVal	:= aScan(oMSNewGeP05:aHeader,{|x| AllTrim(x[2])=="C8_PRECO"})
                                                                              
Local nValItem  := 0
Local k := 0
Local nValCot := 0
Local nUsado := Len(oMSNewGeP05:aHeader) + 1  
Local nTotDesc := 0 
Local nUltLinha := 0                                 
Local nDifDesc  := 0
      
//calcula o valor total da cota��o a ser rateado
For k := 1 To Len(oMSNewGeP05:aCols)
	If !oMSNewGeP05:aCols[k,nUsado+1]
		nValCot += oMSNewGeP05:aCols[k ,nPosQtd] * oMSNewGeP05:aCols[k ,nPosVal]
	EndIf
Next

For k := 1 To Len(oMSNewGeP05:aCols)
	If !oMSNewGeP05:aCols[k,nUsado+1]        
		nValItem := oMSNewGeP05:aCols[k ,nPosQtd] * oMSNewGeP05:aCols[k ,nPosVal]
		nDescItem := Round( (nValItem / nValCot) * nValDesc,2)  
		oMSNewGeP05:aCols[k ,nPosDesc2] := nDescItem
		nUltLinha := k
		nTotDesc += nDescItem
	EndIf
Next                       

If (nDifDesc := (nTotDesc - nValDesc)) <> 0 .And. nUltLinha <> 0
	oMSNewGeP05:aCols[nUltLinha,nPosDesc2] -= nDifDesc	
EndIf

oMSNewGeP05:oBrowse:Refresh()
                                                                             

Return(.T.)       

//------------------------------------------------ 
Static Function fMSNewGe2()
//------------------------------------------------ 
Local nX
Local aHeaderHs    := {}
Local aColsHs      := {}
Local aFieldFill   := {}
Local aFields      := {"C7_ITEM","C7_NUM","C7_PRODUTO","C7_DESCRI","A2_NOME","C7_QUANT","C7_PRECO","C7_TOTAL","C7_EMISSAO","C7_FILIAL","A2_NREDUZ"}
Local nUsado       := Len(aFields)
Local _area        := getarea()  
  
Static oMSNewGe1  

	// Define field properties
	DbSelectArea("SX3")
  	SX3->(DbSetOrder(2))
  	For nX := 1 to Len(aFields)
    	If SX3->(DbSeek(aFields[nX]))
      		Aadd(aHeaderHs, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,IIF((AllTrim(X3Titulo()) == 'Descricao'),30,SX3->X3_TAMANHO),SX3->X3_DECIMAL,SX3->X3_VALID,;
                       SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO,SX3->X3_WHEN,SX3->X3_VISUAL,;
					   SX3->X3_VLDUSER,SX3->X3_PICTVAR,SX3->X3_OBRIGAT})            
	    Endif
  	Next nX
  	
  	cQuery := " SELECT TOP(25) C7_ITEM, C7_NUM, C7_PRODUTO, C7_DESCRI, A2_NOME, C7_QUANT, C7_PRECO, C7_TOTAL, CONVERT(varchar, CONVERT(DATETIME, C7_EMISSAO), 103) AS EMISSAO, C7_FILIAL, A2_NREDUZ  " 
	cQuery += " FROM " + RetSqlName("SC7") + " SC7 "
	cQuery += " INNER JOIN  " + RetSqlName('SA2') + " SA2 ON A2_COD = C7_FORNECE AND A2_LOJA = C7_LOJA AND SA2.D_E_L_E_T_ = '' " 
	cQuery += " WHERE C7_PRODUTO = '"+IIF(oMSNewGeP05:oBrowse:nAt == 0,oMSNewGeP05:aCols[1,18],oMSNewGeP05:aCols[oMSNewGeP05:oBrowse:nAt,18])+"' " 
	cQuery += " AND SC7.D_E_L_E_T_ = '' " 
	cQuery += " ORDER BY C7_EMISSAO DESC "                          

	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TMP", .T., .T.) 

	TMP->(dbGoTop()) 
	While(!TMP->(EOF())) 
	
	  	AAdd(aColsHs, {TMP->C7_ITEM, TMP->C7_NUM, TMP->C7_PRODUTO, Alltrim(TMP->C7_DESCRI), TMP->A2_NOME, TMP->C7_QUANT, TMP->C7_PRECO, TMP->C7_TOTAL, TMP->EMISSAO, TMP->C7_FILIAL ,Substr(FwFilialName(,TMP->C7_FILIAL,2),14,len(FwFilialName(,TMP->C7_FILIAL,2))) ,.F.})	           
	  	TMP->(dbskip())
	EndDo                                                                                                                
	    
	TMP ->(dbCloseArea())
	
	restArea(_area)
  	
  
	 IF(aResolu[1] == 1920 .AND. aResolu[2] == 1080) // MONITOR RESOLU��O 1920 x 1080
	  oMSNewPreco:= MsNewGetDados():New( 244, 006, aPosObj[1,3]+255,aPosObj[1,4]-3, GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "+C7_ITEM",{},, Len(aColsHs), "AllwaysTrue", "", "AllwaysTrue", oDlg, aHeaderHs, aColsHs)
	 ELSE
	  oMSNewPreco:= MsNewGetDados():New( 214, 006, aPosObj[1,3]+156,aPosObj[1,4]-3, GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "+C7_ITEM",{},, Len(aColsHs), "AllwaysTrue", "", "AllwaysTrue", oDlg, aHeaderHs, aColsHs)
	 ENDIF
	  oMSNewPreco:oBrowse:bLDblClick := {|| AFATP1(),oMSNewGeP05:oBrowse:DrawSelect()}
	  oMSNewPreco:oBrowse:Refresh()


Return

/*-------------------------------------------------------------------------------------- 
                          DESENVOLVIMENTOS ADVPL - PROTHEUS                            -                                                    
----------------------------------------------------------------------------------------
DESENVOLVEDOR: CRISTIANO FERREIRA DE OLIVEIRA         ---          DATA: 14/05/2019    - 
----------------------------------------------------------------------------------------
                                   PROGRAMA: AFATP1                                    -
----------------------------------------------------------------------------------------
                       FUN��O PARA VISUALIZA��O DO PEDIDO APROVADO                     -
--------------------------------------------------------------------------------------*/ 

*********************************
Static Function AFATP1()
*********************************

Local cTipPed
Local cLock     := 'N'
Local cNumPed   := oMSNewPreco:aCols[oMSNewPreco:oBrowse:nAt,02]
Local cFilPed   := oMSNewPreco:aCols[oMSNewPreco:oBrowse:nAt,10]
Local lAprova   := 'N' 
Private aRotina	:= {}
Private cEmpAnt
Private nTipoPed  := 2
Private CCADASTRO := "Pedido de Compras - TOPMIX"

/*Monta o Menu*/
aAdd(aRotina,{"Pesquisar"   ,"PesqBrw"   , 0, 1, 0, .F. }) //
aAdd(aRotina,{"Visualizar"  ,"A120Pedido", 0, 2, 0, Nil }) //
	
	RESET ENVIRONMENT
	cEmpAnt := '01'
	PREPARE ENVIRONMENT EMPRESA cEmpAnt FILIAL cFilPed MODULO "COM" TABLES "SXE","SXF","SX2","SX3"
	DbSelectArea("SC7")
 	SC7->(DbSetorder(1))
	If SC7->(DbSeek(cFilPed+cNumPed))	// LOCALIZAR RECNO
	 INCLUI := .F.
	 ALTERA := .F. 
 	 A120Pedido('SC7',SC7->(recno()),2)
 	Endif 
 return () 
 
 