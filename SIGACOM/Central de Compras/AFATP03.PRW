#Include "PROTHEUS.CH"  
#INCLUDE "rwmake.ch"  
#INCLUDE "TOPCONN.CH"
 
/*------------------------------------------------------------------------------------
                          DESENVOLVIMENTOS ADVPL - PROTHEUS                          -                                                    
--------------------------------------------------------------------------------------
DESENVOLVEDOR: CRISTIANO FERREIRA DE OLIVEIRA         ---          DATA: 20/02/2019  - 
--------------------------------------------------------------------------------------
                                   PROGRAMA: AFATP03                                 -
--------------------------------------------------------------------------------------
                            FUN��O PARA GERA��O DE COTA��O                           -
-------------------------------------------------------------------------------------*/                                              
                                                            
******************************************
User Function AFATP03(poWBrowse)          
******************************************
              
Local oBitmap1
Local oBitmap2
Local oGroup1
Local oGroup2
Local oGroup3
Local oSay1
Local oSay2
Local oSay3
Local oSButton1
Local oSButton2 

Local cFilAux   := ""
Local cNUMSC    := ""
Local cEmpres   := "" 
Local lMarcado  := .F.                    
Local lAgrupa   := GetNewPar("MV_ZAGRUSC",.f.)

Private oFont1 := TFont():New("Arial",,022,,.T.,,,,,.F.,.F.)
Private oFont2 := TFont():New("Arial",,020,,.T.,,,,,.F.,.F.)
Private oFont3 := TFont():New("Arial",,018,,.F.,,,,,.F.,.F.)
Private cCotacao  := 0
Private cFilAux   := "      "
Private aPrintCota:={}   
Private poWBrowseAX := {}
Private lCota       := "N"
Private aResolu     := getScreenRes()


dbSelectArea("SY1")
dbSetOrder(3)
if !dbSeek(xFilial("SY1")+RetCodUsr())
	ApMsgInfo("Usu�rio n�o � um comprador cadastrado !!! Cota��o n�o ser� gerada !!!")
	return
endif

Static oDlg      

For x:=1 to Len(poWBrowse) 
    If poWBrowse[x,1]
		lMarcado := .T.
	Endif	
Next

if !lMarcado
	MsgAlert("N�o existe registro marcado !","Aten��o")
	return
endif


dbSelectArea("SA2")
dbSelectArea("SC8")

	cNUMSC:=""

	For nXX:=1 to Len(poWBrowse)   
//		 poWBrowseAX := {}	
	    //verifica se o item foi marcado
	    If poWBrowse[nXX,1]
	
			cFilAux :=poWBrowse[nXX,14]
			cNUMSC  :=poWBrowse[nXX,06]
			cEmpres :=Alltrim(poWBrowse[nXX,03])
			cCodPro :=Alltrim(poWBrowse[nXX,12])                 
			cItemSC :=Alltrim(poWBrowse[nXX,13])

			if !Empty(cFilAux) .And. !Empty(cNUMSC)	.And. !Empty(cEmpres) 	
		    	fSelSAGrupa(cFilAux,cNUMSC,cEmpres,cCodPro,cItemSC)
				aWBrowse    := FSelProGru(poWBrowseAX)
			endif	


			//exit  
		Endif	
	Next 
		
//Endif	

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

  DEFINE MSDIALOG oDlg TITLE "Gera��o de Cota��es" FROM aSize[7],0 TO aSize[6],aSize[5] COLORS 0, 16777215 PIXEL

    @ 003, 006 SAY oSay1 PROMPT "GERAR COTA��O" SIZE 100, 011 OF oDlg FONT oFont1 COLORS 32768, 16777215 PIXEL
    If(aResolu[1] == 1920 .AND. aResolu[2] == 1080) // MONITOR RESOLU��O 1920 x 1080
    @ 016, 002 GROUP oGroup1 TO 425, 955 OF oDlg COLOR 0, 16777215 PIXEL
    @ 021, 005 SAY oSay2 PROMPT "Produtos" SIZE 107, 009 OF oDlg FONT oFont2 COLORS 0, 16777215 PIXEL
    @ 029, 004 GROUP oGroup2 TO 263, 953 OF oDlg COLOR 0, 16777215 PIXEL
    aWBrowAux:=fWBrowse1(aWBrowse)
    @ 266, 005 SAY oSay3 PROMPT "Fornecedores" SIZE 132, 009 OF oDlg FONT oFont2 COLORS 0, 16777215 PIXEL
    @ 276, 005 GROUP oGroup3 TO 422, 953 OF oDlg COLOR 0, 16777215 PIXEL
    DEFINE SBUTTON oSButton1 FROM 430, 750 TYPE 01 ACTION fConfirma(aWBrowAux,oMSNewGe1,poWBrowse) OF oDlg ENABLE
    oSButton1:SetCSS(	"QPushButton{ background-color: #009ACD; color: #E0FFFF; font-size: 12px; border: 1px solid #585858; } " )
    DEFINE SBUTTON oSButton2 FROM 430, 780 TYPE 02  ACTION oDlg:End() OF oDlg ENABLE
    oSButton2:SetCSS(	"QPushButton{ background-color: #009ACD; color: #E0FFFF; font-size: 12px; border: 1px solid #585858; } " )
    Else
    @ 016, 002 GROUP oGroup1 TO 275, 675 OF oDlg COLOR 0, 16777215 PIXEL
    @ 021, 005 SAY oSay2 PROMPT "Produtos" SIZE 107, 009 OF oDlg FONT oFont2 COLORS 0, 16777215 PIXEL
    @ 029, 004 GROUP oGroup2 TO 153, 673 OF oDlg COLOR 0, 16777215 PIXEL
    aWBrowAux:=fWBrowse1(aWBrowse)
    @ 156, 005 SAY oSay3 PROMPT "Fornecedores" SIZE 132, 009 OF oDlg FONT oFont2 COLORS 0, 16777215 PIXEL
    @ 165, 005 GROUP oGroup3 TO 271, 673 OF oDlg COLOR 0, 16777215 PIXEL
    DEFINE SBUTTON oSButton1 FROM 280, 610 TYPE 01 ACTION fConfirma(aWBrowAux,oMSNewGe1,poWBrowse) OF oDlg ENABLE
    oSButton1:SetCSS(	"QPushButton{ background-color: #009ACD; color: #E0FFFF; font-size: 12px; border: 1px solid #585858; } " )
    DEFINE SBUTTON oSButton2 FROM 280, 640 TYPE 02  ACTION oDlg:End() OF oDlg ENABLE
    oSButton2:SetCSS(	"QPushButton{ background-color: #009ACD; color: #E0FFFF; font-size: 12px; border: 1px solid #585858; } " )
    Endif

    fMSNewGe1()
     
  ACTIVATE MSDIALOG oDlg CENTERED

Return

//------------------------------------------------ 
//* Grava cota�ao de pedido de compras   
// SC - Pendentes
//------------------------------------------------ 

Static Function fConfirma(aBrow1,oMSNewGe1,poWBrowse) //
Local lFlag:=.F. 
aHeader:=Aclone(oMSNewGe1:aHeader)

For nX := 1 to Len(oMSNewGe1:aCols)    
	If !oMSNewGe1:aCols[nX,Len(oMSNewGe1:aCols[nX])] .And. !Empty(oMSNewGe1:aCols[nX,GDFieldPos("C7_FORNECE")]) .And. !Empty(oMSNewGe1:aCols[nX,GDFieldPos("C7_LOJA")])
	  lFlag:=.T.
	Endif  
Next
If lFlag     

	MsAguarde( {|lEnd|FGravaSC8(aBrow1,oMSNewGe1,poWBrowse)},"Aguarde","Gravando Registros...",.T.) 

/*	
	For nX := 1 to Len(oMSNewGe1:aCols)    
		If !oMSNewGe1:aCols[nX,Len(oMSNewGe1:aCols[nX])] .And. !Empty(oMSNewGe1:aCols[nX,GDFieldPos("A2_COD")]) .And. !Empty(oMSNewGe1:aCols[nX,GDFieldPos("A2_LOJA")])
			MsAguarde( {|lEnd|u_AFATR03(cCotacao ,oMSNewGe1:aCols[nX,GDFieldPos("A2_COD")],oMSNewGe1:aCols[nX,GDFieldPos("A2_LOJA")] )},"Aguarde","Enviando e-mail para o fornecedor: "+oMSNewGe1:aCols[nX,GDFieldPos("A2_NOME")],.T.)
		Endif	
	Next
*/

	//Envia e-mail para cadas fornecedor com o endere�o informado
	For k := 1 To Len(aPrintCota)
		cCotacao := Left(aPrintCota[k],6)
		cFilAux  := Right(aPrintCota[k],6) 
		
		For nX := 1 to Len(oMSNewGe1:aCols)    
		
			If !oMSNewGe1:aCols[nX,Len(oMSNewGe1:aCols[nX])]        .And. ;
		   	!Empty(oMSNewGe1:aCols[nX,GDFieldPos("C7_FORNECE")]) .And. ;
		   	!Empty(oMSNewGe1:aCols[nX,GDFieldPos("C7_LOJA")])    .And. ;
		   	!Empty(oMSNewGe1:aCols[nX,GDFieldPos("A2_EMAIL")])		   
		
				MsAguarde( {|lEnd|u_AFATR05(cCotacao,;
					oMSNewGe1:aCols[nX,GDFieldPos("C7_FORNECE")],;
					oMSNewGe1:aCols[nX,GDFieldPos("C7_LOJA")],;
					Alltrim(oMSNewGe1:aCols[nX,GDFieldPos("A2_EMAIL")]),;
					cFilAux)},"Aguarde","Enviando e-mail ",.T.)
			Endif
		Next
	Next

	
	oDlg:End()
	
	/*
	Chama relat�rio padr�o de cota��o
	*/
//	Matr150(cCotacao)
	For k:=1 To Len(aPrintCota)
		cCotacao := Left(aPrintCota[k],6)
		cFilAux  := Right(aPrintCota[k],6) 
		U_AFATR08(cCotacao,cFilAux)	
	Next

EndIf

Return(lFlag) 


//------------------------------------------------ 
Static Function fWBrowse1(poWBrowse)
//------------------------------------------------ 
Local oOk := LoadBitmap( GetResources(), "LBOK")
Local oNo := LoadBitmap( GetResources(), "LBNO")
Local oWBrowse1
Local aWBrowse1 := Aclone(poWBrowse)

    If Len(aWBrowse1)=0 
		Aadd(aWBrowse1,{.F.,"","","","","","","","",""})
    Endif
    If(aResolu[1] == 1920 .AND. aResolu[2] == 1080) // MONITOR RESOLU��O 1920 x 1080        
	@ 034, 007 LISTBOX oWBrowse1 Fields HEADER "","Empresa","Filial","Num.SC","Cod.Protheus","Produto","Descri��o","Marca","Aplica��o",;
	"Classifica��o" SIZE 943, 225 OF oDlg FONT oFont3 PIXEL ColSizes 30,30,30,30,30,100,50,50,50
	Else
	@ 034, 007 LISTBOX oWBrowse1 Fields HEADER "","Empresa","Filial","Num.SC","Cod.Protheus","Produto","Descri��o","Marca","Aplica��o",;
	"Classifica��o" SIZE 662, 116 OF oDlg FONT oFont3 PIXEL ColSizes 30,30,30,30,30,100,50,50,50
	Endif
    //@ 034, 007 LISTBOX oWBrowse1 Fields HEADER "","Empresa","Filial","Num.SC","Cod.Protheus","Cod.Original","Descri��o","Aplica��o","Classifica�ao""Quantidade" SIZE 283, 075 OF oDlg FONT oFont3 PIXEL ColSizes 50,50
    oWBrowse1:SetArray(aWBrowse1)
    oWBrowse1:bLine := {|| {;
      If(aWBrowse1[oWBrowse1:nAT,01],oOk,oNo),;
      aWBrowse1[oWBrowse1:nAt,02],;
      aWBrowse1[oWBrowse1:nAt,03],;
      aWBrowse1[oWBrowse1:nAt,04],;
      aWBrowse1[oWBrowse1:nAt,05],;
      aWBrowse1[oWBrowse1:nAt,06],;
      aWBrowse1[oWBrowse1:nAt,07],;
      aWBrowse1[oWBrowse1:nAt,08],;
      aWBrowse1[oWBrowse1:nAt,09],;
      aWBrowse1[oWBrowse1:nAt,10];
    }}
    // DoubleClick event
   	 //oWBrowse1:bLDblClick := {|| aWBrowse1[oWBrowse1:nAt,1] := !aWBrowse1[oWBrowse1:nAt,1],FafatMarca(aWBrowse1[oWBrowse1:nAt,1],aWBrowse1[oWBrowse1:nAt,9],aWBrowse1[oWBrowse1:nAt,4],aWBrowse1[oWBrowse1:nAt,2]),;
   	 oWBrowse1:bLDblClick := {|| aWBrowse1[oWBrowse1:nAt,1] := !aWBrowse1[oWBrowse1:nAt,1],;
     oWBrowse1:DrawSelect()} 
   	 oWBrowse1:Refresh()  // Evento de duplo click na celula
 //  Aadd(aAuxGru,{.T.,cEmpres,cFilial,cNumc,cProduto,cDescri,nQtd,cGrupo,nReg,cItem,cTipo,cMarca })  
  
Return(aWBrowse1)

//------------------------------------------------ 
Static Function fMSNewGe1()
//------------------------------------------------ 
Local nX
Local nY
Local aHeaderEx := {}
Local aColsEx := {}
Local aFieldFill := {}
Local aFields := {"C7_FORNECE","C7_LOJA","A2_NOME","A2_EMAIL"}
Local aAlterFields := {"C7_FORNECE","A2_EMAIL"}
Local cQuery
Static oMSNewGe1
dbSelectArea("SA2")  
  // Define field properties
  DbSelectArea("SX3")
  SX3->(DbSetOrder(2))
  For nX := 1 to Len(aFields)
    If SX3->(DbSeek(aFields[nX]))
      Aadd(aHeaderEx, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL," " ,;
                       SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
    Endif
  Next nX

  // Define field values
  For nX := 1 to Len(aFields)
    If DbSeek(aFields[nX])
      //If aFields[nX]<>"A2_COD" 
      	 Aadd(aFieldFill, CriaVar(SX3->X3_CAMPO))
      //Else
      // 	 Aadd(aFieldFill, Space(6))   
      //	 aHeaderEx[nX,9]:="SA2C"
      // Endif	 
    Endif
  Next nX
  Aadd(aFieldFill, .F.)
  Aadd(aColsEx, aFieldFill) 
  
  cQuery := "SELECT A5_FORNECE, A5_LOJA, A5_NOMEFOR "
  cQuery += "FROM "+RetSqlName("SA5")+" SA5 "
  cQuery += "WHERE SA5.A5_PRODUTO ='"+aWBrowse1[oWBrowse1:nAt,12]+"' "
  cQuery += "AND D_E_L_E_T_ = ' ' "
  cQuery += "ORDER BY R_E_C_N_O_ DESC "
  
  cQuery := ChangeQuery(cQuery)
  dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP",.T.,.T.)
  For nY := 1 To Len(aColsEx) // �LTIMO FORNECEDOR - COMPRA
	  aColsEx[nY][1] := TMP->A5_FORNECE
	  aColsEx[nY][2] := TMP->A5_LOJA
	  aColsEx[nY][3] := TMP->A5_NOMEFOR
  Next nY
  If(aResolu[1] == 1920 .AND. aResolu[2] == 1080) // MONITOR RESOLU��O 1920 x 1080
  oMSNewGe1 := MsNewGetDados():New( 280, 008, 420, 949, GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "AllwaysTrue", aAlterFields,, 999, "AllwaysTrue", "", "AllwaysTrue", oDlg, aHeaderEx, aColsEx)
  Else
  oMSNewGe1 := MsNewGetDados():New( 166, 008, 268, 670, GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "AllwaysTrue", aAlterFields,, 999, "AllwaysTrue", "", "AllwaysTrue", oDlg, aHeaderEx, aColsEx)
  Endif
  dbSelectArea("TMP")
  dbCloseArea("TMP")
  
Return()    

//------------------------------------------------ 
//* Seleciona os produtos e grupos iguais  
// SC - Pendentes
//------------------------------------------------ 
Static Function FSelProGru(aBrow1)
Local x1:=0
Local aWBrowGru := {}  
Local aAuxGru   := {} 
   
//    Aadd(aWBrowse1,{.F.,"Filial","Num.SC","Produto","Descri��o","Quantidade"})
	For x1:=1 to Len(aBrow1) 
 		    cFilAUX	:= aBrow1[x1,03]
 		    cNumc	:= aBrow1[x1,05]
		    cProduto:= aBrow1[x1,06] 
 		    cDescri := aBrow1[x1,07] 
 		    cGrupo  := aBrow1[x1,11]
 		    cItem   := aBrow1[x1,12] 
 		    nQtd    := aBrow1[x1,13]
 		    cFilFat := aBrow1[x1,14] 
 		    nReg    := aBrow1[x1,16] 
 		    cTipo   := aBrow1[x1,17] 
 		    cMarca  := aBrow1[x1,18] 
 		    cEmpres := aBrow1[x1,19] 
 		    cCodOri := aBrow1[x1,22]
 		    cAplica := aBrow1[x1,20]
 		    cClassi := aBrow1[x1,4]//aBrow1[x1,21]
 	        // Armazenas vetor  por produto com quantidade.


	  	   	Aadd(aAuxGru,{.T.,Iif(cEmpres=="01",cEmpres+" - TPX",cEmpres+" - FLP"),cFilAUX,cNumc,cProduto,Alltrim(cCodOri),Alltrim(cDescri),;
	  	   		Alltrim(cMarca),Alltrim(cAplica),Alltrim(cClassi),nQtd,cGrupo,nReg,cItem,cTipo,cMarca, cEmpres })
	  	   	
//	@ 034, 007 LISTBOX oWBrowse1 Fields HEADER "","Empresa","Filial","Num.SC","Cod.Protheus","Produto","Descri��o","Marca","Aplica��o","Classifica��o" SIZE 283, 075 OF oDlg FONT oFont3 PIXEL ColSizes 50,50
	Next       

	aSort(aAuxGru,,,{|x,y| x[8]+x[5] < y[8]+y[5]}) 
	
Return(aAuxGru)

//------------------------------------------------ 
Static Function FafatMarca(pFlag,pReg,pNum,pEmp)
//------------------------------------------------ 
Local cFlag   :='' 
Local _FileLog:= "Afatp03.txt" 
Local _cSql   :=""
IF pEmp=SM0->M0_CODIGO
	dbSelectArea("SC1")
 	dbGoto(pReg) 
	If SC1->C1_ZSTATUS='3'  .And. !pFlag
		RecLock("SC1", .F.)
		SC1->C1_ZSTATUS:="1"
		SC1->(MsUnlock())
	ElseIf SC1->C1_ZSTATUS='1' .And. pFlag
		RecLock("SC1", .F.)
		SC1->C1_ZSTATUS:="3"
		SC1->(MsUnlock())
	Endif                 
Else  
	Begin Transaction    
	        nReg:=Alltrim(str(pReg,10))         
 			IF !pFlag
			  _cSql := "UPDATE SC1" + pEmp + "0 SET C1_ZSTATUS = '1' WHERE R_E_C_N_O_= '" + nReg + "'"
            Else
			  _cSql := "UPDATE SC1" + pEmp + "0 SET C1_ZSTATUS = '3' WHERE R_E_C_N_O_= '" + nReg + "'"
            Endif
			_Retorno := TCSQLExec(_cSql)
	End Transaction	
	If _Retorno < 0 
		_GetErroTop := TCSQLError()							
		MsgStop("Error ocorreram na execucao da Query no banco de dados. Veja detalhes no log Afatp03.TXT","Erro","Alert")
	Endif
Endif
Return()

//------------------------------------------------ 
//* Grava na tabela SC8 cota�ao   
// SC - Pendentes
//------------------------------------------------ 
Static Function FGravaSC8(aBrow1,oMSNewGe1,poWBrowse)
Local x1        := 0
Local aWBrowGru := {}  
Local aAuxGru   := {}    
Local lRet      := .F.
Local nConReg   := 0  
Local cUsrCot   := UsrRetName(RetCodUsr())
Local aReg	    := {}    
Local cNumOcor  := "" 
Local cFilAux   := "" 
Local cFilInc   := ""
Local cFornInc  := ""
Local cLojaInc  := ""
Local cItemInc  := ""
Local cProposta := ""

aHeader:=Aclone(oMSNewGe1:aHeader)
 
	For x1:=1 to Len(aBrow1)  
	    If aBrow1[x1,1]
 		    cFilAux	:=aBrow1[x1,03]
		    cNumc	:=aBrow1[x1,04]
 		    cProduto:=aBrow1[x1,05] 
 		    nQtd    :=aBrow1[x1,11]  
 		    cGrupo  :=aBrow1[x1,12]
 		    cReg    :=aBrow1[x1,13]
		    cItem   :=aBrow1[x1,14] 
 		    cTipo   :=aBrow1[x1,15] 
 		    cMarca  :=aBrow1[x1,16] 
 		    cXXEmp  :=aBrow1[x1,17] 
 		    
	        // Armazenas vetor  por produto com quantidade. e o tipo de produto (Original Sim/N�o)
			nPos:= Ascan(aAuxGru, {|e| e[1]  == cProduto .And. e[7]  == cTipo .And. e[4] == cNumc }) 
		  //	If Empty(nPos)
	  	   		Aadd(aAuxGru,{cProduto,cGrupo,nQtd,cNumc,cItem,cReg,cTipo,cMarca,cXXEmp,cFilAux })  
	  	  //	Else                                                                             
	  		//	aAuxGru[nPos,3]+=nQtd
	  		  //	aAuxGru[nPos,5]:="999"
	  	//	Endif 
	  	Endif	  
	Next     
	            
	dbSelectArea("SM0")    
	
	
	dbSelectArea("SC1")
	dbSetOrder(1)
	
	dbSelectArea("SC8")    

	cCotacao := GetSx8Num("SC8","C8_NUM") 
	ConfirmSX8()        
	aPrintCota := {}

	Begin Transaction   

 		For nX := 1 to Len(oMSNewGe1:aCols)
			If !oMSNewGe1:aCols[nX,Len(oMSNewGe1:aCols[nX])] .And. !Empty(oMSNewGe1:aCols[nX,GDFieldPos("C7_FORNECE")])  

				For x1:=1 to Len(aAuxGru)

						cObsAdi	:= ""
						cObsSC	:= "" // JSantos - 20150304 - Vari�vel para receber a observa��o geral do Solicitante
				
						dbSelectArea("SC1")
						DbSetOrder(1) // filial + numero  + item
						If dbSeek( aAuxGru[x1,10] + aAuxGru[x1,4] + aAuxGru[x1,5] , .T. )
							cObsAdi	:= SC1->C1_ZOBSADI
							cObsSC	:= SC1->C1_OBS
						Else
							dbSeek( aAuxGru[x1,10] + aAuxGru[x1,4],.T.)
							If ! Eof()
								cObsAdi	:= SC1->C1_ZOBSADI
								cObsSC	:= SC1->C1_OBS
							EndIf							
						EndIf

				    	cProduto:=aAuxGru[x1,1]
						cDescri:= Posicione("SB1",1,xFilial("SB1")+aAuxGru[x1,1],"B1_DESC")

                  If aScan(aPrintCota,cCotacao + aAuxGru[x1,10]) = 0
                  	Aadd(aPrintCota,cCotacao + aAuxGru[x1,10])
                  EndIf                             
                                        
                  cFilInc   := aAuxGru[x1,10]
                  cFornInc  := oMSNewGe1:aCols[nx,GDFieldPos("C7_FORNECE")]
                  cLojaInc  := oMSNewGe1:aCols[nx,GDFieldPos("C7_LOJA")]  
                  cItemInc  := StrZero(x1,Len(SC8->C8_ITEM))                   
                  cProposta := "01"
                  
						dbSelectArea("SC8")
						DbSetOrder(1) // C8_FILIAL+C8_NUM+C8_FORNECE+C8_LOJA+C8_ITEM+C8_NUMPRO+C8_ITEMGRD
						DbSeek( cFilInc + cCotacao + cFornInc + cLojaInc + cItemInc + cProposta , .T. )
						
						If ! Eof() .And. SC8->(C8_FILIAL+C8_NUM+C8_FORNECE+C8_LOJA+C8_ITEM+C8_NUMPRO) == cFilInc + cCotacao + cFornInc + cLojaInc + cItemInc + cProposta
						   cProposta := StrZero( Val(SC8->C8_NUMPRO) + 1 , 2 )
						Endif
						    
						RecLock("SC8", .T.)
						SC8->C8_FILIAL  := cFilInc
						SC8->C8_NUM     := cCotacao
	    				SC8->C8_FORNECE := cFornInc
	                	SC8->C8_LOJA    := cLojaInc
						SC8->C8_ITEM    := cItemInc	            	
                        SC8->C8_NUMPRO  := cProposta	            	
	                 	SC8->C8_EMISSAO := date()
	            	    SC8->C8_ZHORA   := time()
		 				SC8->C8_ZUSER   := IIF(Empty(__CUSERID),RetCodUsr(),__CUSERID) 
					//	SC8->C8_NOMCOT  := cUsrCot 
						SC8->C8_EMISSAO := ddatabase 
						SC8->C8_PRODUTO := aAuxGru[x1,1]
						SC8->C8_IDENT   := cItemInc
						SC8->C8_QUANT   := aAuxGru[x1,3]
						SC8->C8_ZQUANTIN:= aAuxGru[x1,3]
						SC8->C8_NUMSC   := aAuxGru[x1,4]    
						SC8->C8_ITEMSC  := aAuxGru[x1,5]    
						SC8->C8_ZTIPOPR := aAuxGru[x1,7]    
						SC8->C8_ZMARCA  := aAuxGru[x1,8]  
						SC8->C8_ZOBSADI := cObsAdi
						SC8->C8_MOEDA   := 1  
						SC8->C8_ZDESCRI := cDescri  
		    		    SC8->C8_ZEMAIL  := Posicione("SA2",1,xFilial("SA2")+oMSNewGe1:aCols[nx,GDFieldPos("C7_FORNECE")]+oMSNewGe1:aCols[nx,GDFieldPos("C7_LOJA")],"A2_EMAIL")  
						SC8->C8_UM      := Posicione("SB1",1,xFilial("SB1")+aAuxGru[x1,1],"B1_UM")   
		    		    SC8->C8_ZSTATUS := "3"    
		    		    SC8->C8_ZEMP    := aAuxGru[x1,9]
		    		    SC8->C8_OBS     := cObsSC
		    		    SC8->C8_ZSOLIC  := Posicione("SC1",1,cFilInc+aAuxGru[x1,4]+aAuxGru[x1,5],"C1_SOLICIT")
		    		    SC8->C8_ZAPLIC  := Posicione("SC1",1,cFilInc+aAuxGru[x1,4]+aAuxGru[x1,5],"C1_ZAPLIC")
		    		    SC8->C8_CC      := Posicione("SC1",1,cFilInc+aAuxGru[x1,4]+aAuxGru[x1,5],"C1_CC")
		    		    SC8->C8_FILENT  := Posicione("SC1",1,cFilInc+aAuxGru[x1,4]+aAuxGru[x1,5],"C1_FILENT")
		    		    SC8->C8_ZFILFAT := Posicione("SC1",1,cFilInc+aAuxGru[x1,4]+aAuxGru[x1,5],"C1_ZFILFAT")
		    		    SC8->C8_TPDOC   := '1'
		    		    SC8->C8_FORNOME := Posicione("SA2",1,xFilial("SA2")+oMSNewGe1:aCols[nx,GDFieldPos("C7_FORNECE")]+oMSNewGe1:aCols[nx,GDFieldPos("C7_LOJA")],"A2_NOME")
					   MsUnLock()   
					              
					dbSelectArea("SZ2") 
					cNumOcor:= GetSxENum("SZ2","Z2_NUMERO") 
					ConfirmSX8()
	 				dbSelectArea("SZ2")   
					If RecLock("SZ2", .T.)      
							SZ2->Z2_FILIAL   := aAuxGru[x1,10]
							SZ2->Z2_NUMERO   := cNumOcor
					 		SZ2->Z2_CODIGO   := '002'
					    	SZ2->Z2_NUMSC    := aAuxGru[x1,4] 
					    	SZ2->Z2_ITEMSC   := aAuxGru[x1,5]
					    	SZ2->Z2_NUMCOT   := cCotacao
					    	SZ2->Z2_PRODUTO  := aAuxGru[x1,1]//SC1->C1_PRODUTO
					    	SZ2->Z2_CODUSR   := cCodCot
					    	SZ2->Z2_NOMEUSR  := cUsrCot
					    	SZ2->Z2_DATA     := DATE()
					    	SZ2->Z2_HORA     := TIME()
					    	SZ2->Z2_MOTIVO   := "GERA COTA��O"
					    	SZ2->Z2_EMAIL1   := ""
					    	SZ2->Z2_EMAIL2   := ""
					    	SZ2->Z2_EMAIL3   := ""
					    	SZ2->Z2_EMAIL4   := ""
					    	SZ2->Z2_EMAIL5   := ""
					 		MsUnLock()  
							lRet:=.T. 
					Endif
						  
				Next	
			Endif
		Next nX	  
		FGravaSC1(aBrow1,cCotacao)
		lCota := 'S'	
	End Transaction 
	ConfirmSx8()
	If (lCota == 'S')
	 MsgInfo("Cota��o"+' '+cCotacao+' '+"foi gerada com sucesso.") 
	Endif 
		
Return(lRet)  

//------------------------------------------------ 
//* Grava na tabela SC1 o numero da cotacao   
// SC - Pendentes
//------------------------------------------------ 
Static Function FGravaSC1(aBrow1,pCotacao) 
Local aArea    := GetArea()  
Local _cSql    :="" 
Local nReg     :=0
For x1:=1 to Len(aBrow1)  
   	If aBrow1[x1,1]  
   	    If SubStr(aBrow1[x1,2],1,2) == SM0->M0_CODIGO
		    nReg    := aBrow1[x1,13]
			dbSelectArea("SC1")
		 	dbGoto(nReg) 
			RecLock("SC1", .F.)   
				SC1->C1_COTACAO :=pCotacao
				SC1->C1_ZSTATUS :="3"
			SC1->(MsUnlock())
	    Else     
		    cEmpres	:=Left(aBrow1[x1,03],2)
 		    nReg    :=Alltrim(str(aBrow1[x1,13],10))
		    _cSql := "UPDATE SC1" + cEmpres + "0 SET C1_ZSTATUS = '3',C1_COTACAO= '"+pCotacao+"' WHERE R_E_C_N_O_= '" + nReg + "'"
		    _Retorno := TCSQLExec(_cSql)
			If _Retorno < 0 
				_GetErroTop := TCSQLError()							
				MsgStop("Error ocorreram na execucao da Query no banco de dados"+_cSql,"Erro","Alert")
			Endif 
		Endif	 
	Endif	
Next                     


RestArea(aArea)
Return()
                         
//------------------------------------------------ 
// Faz o agrupamento de todas as solicita�ao
//------------------------------------------------ 
Static Function fSelAGrupa(pEmpr)

Local aAliasOLD := GetArea()
Local cAliasQry := GetNextAlias()      
Local cCodUser  := RetCodUsr() 
Local aWBrowAux := {}              
Local aClassi   := {}
Local cClassi   :=""  
Local nRegSM0   := 0
Local aEmpresa  :={}
Local cEmpAux   :=""
Local cFromSC1  := "%"+"SC1"+cEmpAux+"%"
Local cFromSB1  := "%"+"SB1"+cEmpAux+"%"

dbSelectArea("SX3")
SX3->(dbSetOrder(02))
If SX3->(dbSeek("C1_ZCLASSI"))
	cClassi := Alltrim(SX3->X3_CBOX)
Endif		                                         
XX:=0
Do While !Empty(cClassi)   
	aAdd(aClassi,SubStr(cClassi,03,IIf(!Empty(AT(";",cClassi)),AT(";",cClassi)-3,Len(cClassi) )) )
	cClassi := SubStr(cClassi,Len(aClassi[Len(aClassi)])+04,Len(cClassi))
Enddo

aEmpresa:=u_fSIGAMAT()// Funcao para buscar as empresas

For xE:=1 to Len(aEmpresa)                                       
	cEmpAux  := aEmpresa[xE,1]+"0"	
	cFromSC1 := "%"+"SC1"+cEmpAux+"%"
	cFromSB1 := "%"+"SB1"+cEmpAux+"%"  
	
	//%Exp:cFromSB1%

	BeginSql Alias cAliasQry
	 
		COLUMN C1_DATPRF AS DATE
        
	 	SELECT C1_ZEMP,C1_FILIAL, C1_ZSTATUS,C1_ZCLASSI, C1_NUM,C1_PRODUTO, C1_DESCRI,C1_QUANT, C1_UM,C1_DATPRF,B1_GRUPO,C1_ITEM,C1_ZFILFAT,
	 	C1_FILENT,C1_ZTIPOPR,C1_ZMARCA,SC1.R_E_C_N_O_ AS RECSC1, C1_ZAPLIC, B1_ZREF1, B1_FABRIC, C1_CC
		FROM %Exp:cFromSC1% SC1                                                 
		INNER JOIN %Exp:cFromSB1% SB1 ON SC1.C1_PRODUTO = SB1.B1_COD AND SB1.%notDel%   
		WHERE SC1.%notDel% 	AND            
  		SC1.C1_ZSTATUS IN (%Exp:'1'%) 
      	ORDER BY C1_ZCLASSI,B1_GRUPO   
      	              		
  	EndSql   
	(cAliasQry)->( DbGoTop() )
 	While !(cAliasQry)->(EOF())  

        Aadd(aWBrowAux,{.F.,;          				// Marca    	1 
        	fGetFlag((cAliasQry)->C1_ZSTATUS),;     // Flag     	2
        	(cAliasQry)->C1_FILIAL,;  				// Filial   	3
        	aClassi[val((cAliasQry)->C1_ZCLASSI)],; // Status     	4 
        	(cAliasQry)->C1_NUM,;     				// Numero SC  	5
        	(cAliasQry)->C1_PRODUTO,; 				// Produto    	6
        	(cAliasQry)->C1_DESCRI,;  				// Desc Produto 7
        	Transform( (cAliasQry)->C1_QUANT,"@E 999,999,999.99"),;   //Quantidade 8
       		(cAliasQry)->C1_UM,;      				// Unidade			9
        	(cAliasQry)->C1_DATPRF,; 				// Data Nescessidade 10
        	(cAliasQry)->B1_GRUPO,;   				// Grupo 			 11
        	(cAliasQry)->C1_ITEM,;  				// Item  			 12 
        	(cAliasQry)->C1_QUANT,; 				// Quantidade 		 13   
        	(cAliasQry)->C1_ZFILFAT,;                // Filial fatura    14
        	(cAliasQry)->C1_FILENT,;                // Filial Entrega    15
        	(cAliasQry)->RECSC1,;                   // Registro          16 
        	(cAliasQry)->C1_ZTIPOPR,;               // Tipo do produto   17 
        	(cAliasQry)->C1_ZMARCA,;                // Marca do produto  18 
        	(cAliasQry)->C1_ZEMP,;                   // Empresa          19
        	(cAliasQry)->C1_ZAPLIC,;                // Aplica��o         20 
        	(cAliasQry)->C1_ZCLASSI,;               // Classifica��o     21
        	(cAliasQry)->B1_ZREF1,;                 // Cod.Original      22
        	(cAliasQry)->B1_FABRIC,;               // Marca		         23 
        	(cAliasQry)->C1_CC})                   // Centro de Custo    24
        	 
        (cAliasQry)->(dbskip())  
	EndDo
	
	(cAliasQry)->(dbCloseArea())
Next    
RestArea(aAliasOLD)
Return(aWBrowAux)  
                          
//------------------------------------------------ 
// Faz a sele�ao sem agruprar as solicita�ao
// apenas a marcada
//------------------------------------------------ 
Static Function fSelSAGrupa(pFilial,pSolicita,pEmpes,pCodPro,pItemSC)

Local aAliasOLD := GetArea()
Local cAliasQry := GetNextAlias()      
Local cCodUser  := RetCodUsr() 
Local aWBrowAux := {}              
Local aClassi   := {}
Local cClassi   :=""  
local nRegSM0   := 0
Local aEmpresa  :={}
Local cEmpAux   :=""
Local cFromSC1  := ""
Local cFromSB1  := ""
                           

dbSelectArea("SX3")
SX3->(dbSetOrder(02))
If SX3->(dbSeek("C1_ZCLASSI"))
	cClassi := Alltrim(SX3->X3_CBOX)
Endif		                                         
XX:=0
Do While !Empty(cClassi)   
	aAdd(aClassi,SubStr(cClassi,03,IIf(!Empty(AT(";",cClassi)),AT(";",cClassi)-3,Len(cClassi) )) )
	cClassi := SubStr(cClassi,Len(aClassi[Len(aClassi)])+04,Len(cClassi))
Enddo 
//aEmpresa:=u_fSIGAMAT()// Funcao para buscar as empresas

//For xE:=1 to Len(aEmpresa)                                      
 	//cEmpAux  := aEmpresa[xE,1]+"0"	
	//cFromSC1 := "%"+"SC1"+cEmpAux+"%"
	//cFromSB1 := "%"+"SB1"+cEmpAux+"%" 
	
 	cEmpAux  := pEmpes+"0"	
	cFromSC1 := "%"+"SC1"+cEmpAux+"%"
	cFromSB1 := "%"+"SB1"+cEmpAux+"%" 
	
		
	BeginSql Alias cAliasQry
		COLUMN C1_DATPRF AS DATE
	 	SELECT C1_ZEMP, C1_FILIAL, C1_ZSTATUS, C1_ZCLASSI, C1_NUM, C1_PRODUTO, B1_DESC, C1_QUANT, C1_UM,C1_DATPRF,B1_GRUPO,C1_ITEM,C1_ZFILFAT,C1_FILENT,
	 	C1_ZTIPOPR, C1_ZMARCA, SC1.R_E_C_N_O_ AS RECSC1, C1_ZAPLIC, B1_ZREF1, B1_FABRIC, C1_CC 
		FROM %Exp:cFromSC1% SC1                                                 
		INNER JOIN %Exp:cFromSB1% SB1 ON SC1.C1_PRODUTO = SB1.B1_COD AND SB1.%notDel%   
		WHERE SC1.%notDel% 	AND            
  		SC1.C1_ZSTATUS IN (%Exp:'1'%)      AND
   		SC1.C1_FILIAL   = %Exp:pFilial%    AND
   		SC1.C1_NUM      = %Exp:pSolicita%  AND
   		SC1.C1_PRODUTO  = %Exp:pCodPro% AND
   		SC1.C1_ITEM     = %Exp:pItemSC%
      	ORDER BY C1_ZCLASSI,B1_GRUPO   
  	EndSql   
	(cAliasQry)->( DbGoTop() )
 	While !(cAliasQry)->(EOF())  
        
        Aadd(poWBrowseAX,{.F.,;          			// Marca    	1 
        	fGetFlag((cAliasQry)->C1_ZSTATUS),;     // Flag     	2
        	(cAliasQry)->C1_FILIAL,;  				// Filial   	3
        	aClassi[val((cAliasQry)->C1_ZCLASSI)],; // Status     	4 
        	(cAliasQry)->C1_NUM,;     				// Numero SC  	5
        	(cAliasQry)->C1_PRODUTO,; 				// Produto    	6
        	(cAliasQry)->B1_DESC,;  				// Desc Produto 7
        	Transform((cAliasQry)->C1_QUANT,"@E 999,999,999.99"),;   //Quantidade 8
       		(cAliasQry)->C1_UM,;      				// Unidade			 09
        	(cAliasQry)->C1_DATPRF,; 				// Data Nescessidade 10
        	(cAliasQry)->B1_GRUPO,;   				// Grupo 			 11
        	(cAliasQry)->C1_ITEM,;  				// Item  			 12 
        	(cAliasQry)->C1_QUANT,; 				// Quantidade 		 13   
        	(cAliasQry)->C1_ZFILFAT,;               // Filial fatura     14
        	(cAliasQry)->C1_FILENT,;                // Filial Entrega    15
        	(cAliasQry)->RECSC1,;                   // Registro          16 
        	(cAliasQry)->C1_ZTIPOPR,;               // Tipo do produto   17 
        	(cAliasQry)->C1_ZMARCA,;                // Marca do produto  18 
        	(cAliasQry)->C1_ZEMP,;                  // Empresa           19
        	(cAliasQry)->C1_ZAPLIC,;                // Aplica��o         20 
        	(cAliasQry)->C1_ZCLASSI,;               // Classifica��o     21
        	(cAliasQry)->B1_ZREF1,;                 // Cod.Original      22
        	(cAliasQry)->B1_FABRIC,;                // Marca		     23        	 
            (cAliasQry)->C1_CC  })                  // Centro de Custo   24
        (cAliasQry)->(dbskip())  
	EndDo
	
	(cAliasQry)->(dbCloseArea())
//Next     

RestArea(aAliasOLD)

//Return(aWBrowAux)  
Return  
                          
//------------------------------------------------ 
// Faz a sele�ao como agrupamento de solicitacao
// apenas a marcada
//------------------------------------------------ 
Static Function SelSAGrupa(poWBrowse)

Local aAliasOLD := GetArea()
Local cAliasQry := GetNextAlias()      
Local cCodUser  := RetCodUsr() 
Local aWBrowAux := {}              
Local aClassi   := {}
Local cClassi   :=""  
local nRegSM0   := 0
Local aEmpresa  :={}
Local cEmpAux   :=""
Local cFromSC1  := ""
Local cFromSB1  := ""
                           

dbSelectArea("SX3")
SX3->(dbSetOrder(02))
If SX3->(dbSeek("C1_ZCLASSI"))
	cClassi := Alltrim(SX3->X3_CBOX)
Endif		                                         
XX:=0
Do While !Empty(cClassi)   
	aAdd(aClassi,SubStr(cClassi,03,IIf(!Empty(AT(";",cClassi)),AT(";",cClassi)-3,Len(cClassi) )) )
	cClassi := SubStr(cClassi,Len(aClassi[Len(aClassi)])+04,Len(cClassi))
Enddo 
//aEmpresa:=u_fSIGAMAT()// Funcao para buscar as empresas


For xE:=1 to Len(poWBrowse)   

	If poWBrowse[xE,1]
		
		pFilial   :=poWBrowse[xE,04]
		pSolicita :=poWBrowse[xE,06]
		pItemSC   :=poWBrowse[xE,13]
		pCodPro   :=poWBrowse[xE,12]
		cEmpres   :=Alltrim(poWBrowse[xE,03])
  	 	cEmpAux   := cEmpres+"0"	
		cFromSC1  := "%"+"SC1"+cEmpAux+"%"
		cFromSB1  := "%"+"SB1"+cEmpAux+"%"     
		
		BeginSql Alias cAliasQry
			COLUMN C1_DATPRF AS DATE
		 	SELECT C1_ZEMP,C1_FILIAL, C1_ZSTATUS,C1_ZCLASSI, C1_NUM,C1_PRODUTO, B1_DESC,C1_QUANT, C1_UM,C1_DATPRF,B1_GRUPO,C1_ITEM,C1_ZFILFAT,C1_FILENT,
		 	C1_ZTIPOPR,C1_ZMARCA,SC1.R_E_C_N_O_ AS RECSC1, C1_ZAPLIC, C1_CC
			FROM %Exp:cFromSC1% SC1                                                 
			INNER JOIN %Exp:cFromSB1% SB1 ON SC1.C1_PRODUTO = SB1.B1_COD AND SB1.%notDel%   
			WHERE SC1.%notDel% 	AND            
	  		SC1.C1_ZSTATUS IN (%Exp:'1'%)      AND
	   		SC1.C1_FILIAL   = %Exp:pFilial%    AND
	   		SC1.C1_NUM      = %Exp:pSolicita%  AND
	   		SC1.C1_PRODUTO  = %Exp:pCodPro%  AND
	   		SC1.C1_ITEM   = %Exp:pItemSC% 
	      	ORDER BY C1_ZCLASSI,B1_GRUPO   
	  	EndSql   
		(cAliasQry)->( DbGoTop() )
	 	While !(cAliasQry)->(EOF())  
	
	        Aadd(aWBrowAux,{.F.,;          				// Marca    	1 
	        	fGetFlag((cAliasQry)->C1_ZSTATUS),;     // Flag     	2
	        	(cAliasQry)->C1_FILIAL,;  				// Filial   	3
	        	aClassi[val((cAliasQry)->C1_ZCLASSI)],; // Status     	4 
	        	(cAliasQry)->C1_NUM,;     				// Numero SC  	5
	        	(cAliasQry)->C1_PRODUTO,; 				// Produto    	6
	        	(cAliasQry)->B1_DESC,;  				// Desc Produto 7
	        	Transform( (cAliasQry)->C1_QUANT,"@E 999,999,999.99"),;   //Quantidade 8
	       		(cAliasQry)->C1_UM,;      				// Unidade			 09
	        	(cAliasQry)->C1_DATPRF,; 				// Data Nescessidade 10
	        	(cAliasQry)->B1_GRUPO,;   				// Grupo 			 11
	        	(cAliasQry)->C1_ITEM,;  				// Item  			 12 
	        	(cAliasQry)->C1_QUANT,; 				// Quantidade 		 13   
	        	(cAliasQry)->C1_ZFILFAT,;               // Filial fatura     14
	        	(cAliasQry)->C1_FILENT,;                // Filial Entrega    15
	        	(cAliasQry)->RECSC1,;                   // Registro          16 
	        	(cAliasQry)->C1_ZTIPOPR,;               // Tipo do produto   17 
	        	(cAliasQry)->C1_ZMARCA,;                // Marca do produto  18 
	        	(cAliasQry)->C1_ZEMP,;                   // Empresa           19
	        	(cAliasQry)->C1_ZAPLIC,;                // Aplica��o         20 
	        	(cAliasQry)->C1_ZCLASSI,;               // Classifica��o     21
	        	Posicione("SB1",1,xFilial("SB1")+(cAliasQry)->C1_PRODUTO,"B1_ZREF1"),;               // Cod.Original      22
	        	Posicione("SB1",1,xFilial("SB1")+(cAliasQry)->C1_PRODUTO,"B1_FABRIC"),;               // Marca		     23
	            (cAliasQry)->C1_CC	})        		     // Centro de Custo   	 
	        (cAliasQry)->(dbskip())  
		EndDo
		
		(cAliasQry)->(dbCloseArea())   
	Endif	
Next     
	
RestArea(aAliasOLD)
Return(aWBrowAux)  


                                                                                                    