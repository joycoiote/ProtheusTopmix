#INCLUDE "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AFATP19   �Autor  �Fausto Neto         � Data �  03/10/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Inclus�o de novo fornecedor.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
************************************
User Function AFATP19()
************************************
*
*
// Variaveis Locais da Funcao

// Variaveis da Funcao de Controle e GertArea/RestArea
Local _aArea   		:= {}
Local _aAlias  		:= {}
// Variaveis Private da Funcao
Private oDlg				// Dialog Principal
// Variaveis que definem a Acao do Formulario
Private VISUAL := .F.                        
Private INCLUI := .F.                        
Private ALTERA := .F.                        
Private DELETA := .F.                        
// Privates das NewGetDados
Private oGetDados1
// Privates das ListBoxes
Private aListBox1 := {}
Private oListBox1    

Private oOk 	 := LoadBitmap( GetResources(), "LBOK"       )
Private oNo 	 := LoadBitmap( GetResources(), "LBNO"       )   

Private cZNumCot  := aWBrowse2[oWBrowse2:nAt,2]           
Private cZFilAux  := aWBrowse2[oWBrowse2:nAt,6]
Private cXXCodUsr := RetCodUsr()

if Empty(cZNumCot)
	ApMsgInfo("N�o existe cota��o a ser selecionada !!!")
	return
endif   

DEFINE MSDIALOG oDlg TITLE "Fornecedores" FROM C(178),C(181) TO C(538),C(800) PIXEL

// Defina aqui a chamada dos Aliases para o GetArea
//CtrlArea(1,@_aArea,@_aAlias,{"SA1","SA2"}) // GetArea

	// Cria as Groups do Sistema
	@ C(002),C(002) TO C(080),C(320) LABEL "Produtos" PIXEL OF oDlg
	@ C(080),C(002) TO C(164),C(320) LABEL "Fornecedores" PIXEL OF oDlg

	// Cria Componentes Padroes do Sistema
	@ C(166),C(186) Button "&Todos" Size C(037),C(012) Action fTodos() PIXEL OF oDlg
	@ C(166),C(226) Button "&Confirmar" Size C(037),C(012) Action fConf() PIXEL OF oDlg
	@ C(166),C(266) Button "&Fechar" Size C(037),C(012) Action oDlg:End() PIXEL OF oDlg

	// Cria ExecBlocks dos Componentes Padroes do Sistema

	// Chamadas das ListBox do Sistema
	fListBox1() 
	fCarrega()
	
	// Chamadas das GetDados do Sistema
	fGetDados1()	
	

//CtrlArea(2,_aArea,_aAlias) // RestArea

ACTIVATE MSDIALOG oDlg CENTERED 

Return(.T.)

/*����������������������������������������������������������������������������������
������������������������������������������������������������������������������������
��������������������������������������������������������������������������������Ŀ��
���Programa   �fGetDados1()� Autor � Fausto Neto               � Data �03/10/2014���
��������������������������������������������������������������������������������Ĵ��
���Descricao  � Montagem da GetDados                                             ���
��������������������������������������������������������������������������������Ĵ��
���Observacao � O Objeto oGetDados1 foi criado como Private no inicio do Fonte   ���
���           � desta forma voce podera trata-lo em qualquer parte do            ���
���           � seu programa:                                                    ���
���           �                                                                  ���
���           � Para acessar o aCols desta MsNewGetDados: oGetDados1:aCols[nX,nY]���
���           � Para acessar o aHeader: oGetDados1:aHeader[nX,nY]                ���
���           � Para acessar o "n"    : oGetDados1:nAT                           ���
���������������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������������
����������������������������������������������������������������������������������*/
Static Function fGetDados1()
// Variaveis deste Form                                                                                                         
Local nX			:= 0                                                                                                              
//�����������������������������������Ŀ
//� Variaveis da MsNewGetDados()      �
//�������������������������������������
// Vetor responsavel pela montagem da aHeader
Local aCpoGDa       := {"C7_FORNECE","C7_LOJA","A2_NOME","A2_EMAIL"}           
// Vetor com os campos que poderao ser alterados                                                                                
Local aAlter       	:= {"C7_FORNECE","A2_EMAIL"}
Local nSuperior    	:= C(088)           // Distancia entre a MsNewGetDados e o extremidade superior do objeto que a contem
Local nEsquerda    	:= C(004)           // Distancia entre a MsNewGetDados e o extremidade esquerda do objeto que a contem
Local nInferior    	:= C(162)           // Distancia entre a MsNewGetDados e o extremidade inferior do objeto que a contem
Local nDireita     	:= C(305)           // Distancia entre a MsNewGetDados e o extremidade direita  do objeto que a contem
// Posicao do elemento do vetor aRotina que a MsNewGetDados usara como referencia  
Local nOpc         	:= GD_INSERT+GD_DELETE+GD_UPDATE                                                                            
Local cLinOk       	:= "AllwaysTrue"    // Funcao executada para validar o contexto da linha atual do aCols                  
Local cTudoOk      	:= "AllwaysTrue"    // Funcao executada para validar o contexto geral da MsNewGetDados (todo aCols)      
Local cIniCpos     	:= ""               // Nome dos campos do tipo caracter que utilizarao incremento automatico.            
                                         // Este parametro deve ser no formato "+<nome do primeiro campo>+<nome do            
                                         // segundo campo>+..."                                                               
Local nFreeze      	:= 000              // Campos estaticos na GetDados.                                                               
Local nMax         	:= 999              // Numero maximo de linhas permitidas. Valor padrao 99                           
Local cFieldOk     	:= "AllwaysTrue"    // Funcao executada na validacao do campo                                           
Local cSuperDel     := ""              // Funcao executada quando pressionada as teclas <Ctrl>+<Delete>                    
Local cDelOk        := "AllwaysTrue"   // Funcao executada para validar a exclusao de uma linha do aCols                   
// Objeto no qual a MsNewGetDados sera criada                                      
Local oWnd          	:= oDlg                                                                                                  
Local aHead        	:= {}               // Array a ser tratado internamente na MsNewGetDados como aHeader                    
Local aCol         	:= {}               // Array a ser tratado internamente na MsNewGetDados como aCols                      
                                                                                                                                
// Carrega aHead                                                                                                                
DbSelectArea("SX3")                                                                                                             
SX3->(DbSetOrder(2)) // Campo                                                                                                   
For nX := 1 to Len(aCpoGDa)                                                                                                     
	If SX3->(DbSeek(aCpoGDa[nX]))                                                                                                 
		Aadd(aHead,{ AllTrim(X3Titulo()),;                                                                                         
			SX3->X3_CAMPO	,;                                                                                                       
			SX3->X3_PICTURE,;                                                                                                       
			SX3->X3_TAMANHO,;                                                                                                       
			SX3->X3_DECIMAL,;                                                                                                       
			SX3->X3_VALID	,;                                                                                                       
			SX3->X3_USADO	,;                                                                                                       
			SX3->X3_TIPO	,;                                                                                                       
			SX3->X3_F3 		,;                                                                                                       
			SX3->X3_CONTEXT,;                                                                                                       
			SX3->X3_CBOX	,;                                                                                                       
			SX3->X3_RELACAO})                                                                                                       
	Endif                                                                                                                         
Next nX                                                                                                                         
// Carregue aqui a Montagem da sua aCol                                                                                         
aAux := {}                          
For nX := 1 to Len(aCpoGDa)         
	If DbSeek(aCpoGDa[nX])             
		Aadd(aAux,CriaVar(SX3->X3_CAMPO))
	Endif                              
Next nX                             
Aadd(aAux,.F.)                      
Aadd(aCol,aAux)                     

oGetDados1:= MsNewGetDados():New(nSuperior,nEsquerda,nInferior,nDireita,nOpc,cLinOk,cTudoOk,cIniCpos,;                               
                             aAlter,nFreeze,nMax,cFieldOk,cSuperDel,cDelOk,oWnd,aHead,aCol)                                   

// Cria ExecBlocks da GetDados

Return Nil                                                                                                                      

/*������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Programa   �fListBox1() � Autor � Fausto Neto           � Data �03/10/2014���
����������������������������������������������������������������������������Ĵ��
���Descricao  � Montagem da ListBox                                          ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
������������������������������������������������������������������������������*/
Static Function fListBox1()


	// Para editar os Campos da ListBox inclua a linha abaixo          
	// na opcao de DuploClick da mesma, ou onde for mais conveniente   
	// lembre-se de mudar a picture respeitando a coluna a ser editada 
	// PS: Para habilitar o DuploClick selecione a op��o MarkBrowse da 
	//     ListBox para SIM.                                           
	// lEditCell( aListBox, oListBox, "@!", oListBox:ColPos )          

	// Carrege aqui sua array da Listbox
	Aadd(aListBox1,{.F.,"","","","","","","",""})

	@ C(008),C(004) ListBox oListBox1 Fields ;
		HEADER "","Empresa","Filial","Num.SC","Cod.Protheus","Produto","Descri��o","Marca","Item Cot";
		Size C(302),C(066) Of oDlg Pixel;
		ColSizes 10,20,20,50,40,40,100,100;
	On DBLCLICK ( aListBox1[oListBox1:nAt,1] := !(aListBox1[oListBox1:nAt,1]), oListBox1:Refresh() )
	oListBox1:SetArray(aListBox1)

	// Cria ExecBlocks das ListBoxes
	oListBox1:bLine 		:= {|| {;
	If(aListBox1[oListBox1:nAT,1],oOk,oNo),;
		aListBox1[oListBox1:nAT,02],;
		aListBox1[oListBox1:nAT,03],;
		aListBox1[oListBox1:nAT,04],;
		aListBox1[oListBox1:nAT,05],;
		aListBox1[oListBox1:nAT,06],;
		aListBox1[oListBox1:nAT,07],;
		aListBox1[oListBox1:nAT,08],;
		aListBox1[oListBox1:nAt,11]}} 
		
Return Nil                                                                                                                      

/*������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Programa   �   C()   � Autores � Norbert/Ernani/Mansano � Data �10/05/2005���
����������������������������������������������������������������������������Ĵ��
���Descricao  � Funcao responsavel por manter o Layout independente da       ���
���           � resolucao horizontal do Monitor do Usuario.                  ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
������������������������������������������������������������������������������*/
Static Function C(nTam)                                                         
Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor     
	If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)  
		nTam *= 0.8                                                                
	ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600                
		nTam *= 1                                                                  
	Else	// Resolucao 1024x768 e acima                                           
		nTam *= 1.28                                                               
	EndIf                                                                         
                                                                                
	//���������������������������Ŀ                                               
	//�Tratamento para tema "Flat"�                                               
	//�����������������������������                                               
	If "MP8" $ oApp:cVersion                                                      
		If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()                      
			nTam *= 0.90                                                            
		EndIf                                                                      
	EndIf                                                                         
Return Int(nTam)                                                                

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CtrlArea � Autor �Ricardo Mansano     � Data � 18/05/2005  ���
�������������������������������������������������������������������������͹��
���Locacao   � Fab.Tradicional  �Contato � mansano@microsiga.com.br       ���
�������������������������������������������������������������������������͹��
���Descricao � Static Function auxiliar no GetArea e ResArea retornando   ���
���          � o ponteiro nos Aliases descritos na chamada da Funcao.     ���
���          � Exemplo:                                                   ���
���          � Local _aArea  := {} // Array que contera o GetArea         ���
���          � Local _aAlias := {} // Array que contera o                 ���
���          �                     // Alias(), IndexOrd(), Recno()        ���
���          �                                                            ���
���          � // Chama a Funcao como GetArea                             ���
���          � P_CtrlArea(1,@_aArea,@_aAlias,{"SL1","SL2","SL4"})         ���
���          �                                                            ���
���          � // Chama a Funcao como RestArea                            ���
���          � P_CtrlArea(2,_aArea,_aAlias)                               ���
�������������������������������������������������������������������������͹��
���Parametros� nTipo   = 1=GetArea / 2=RestArea                           ���
���          � _aArea  = Array passado por referencia que contera GetArea ���
���          � _aAlias = Array passado por referencia que contera         ���
���          �           {Alias(), IndexOrd(), Recno()}                   ���
���          � _aArqs  = Array com Aliases que se deseja Salvar o GetArea ���
�������������������������������������������������������������������������͹��
���Aplicacao � Generica.                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function CtrlArea(_nTipo,_aArea,_aAlias,_aArqs)                       
Local _nN                                                                    
	// Tipo 1 = GetArea()                                                      
	If _nTipo == 1                                                             
		_aArea   := GetArea()                                                    
		For _nN  := 1 To Len(_aArqs)                                             
			DbSelectArea(_aArqs[_nN])                                              
			AAdd(_aAlias,{ Alias(), IndexOrd(), Recno()})                          
		Next                                                                     
	// Tipo 2 = RestArea()                                                     
	Else                                                                       
		For _nN := 1 To Len(_aAlias)                                             
			DbSelectArea(_aAlias[_nN,1])                                           
			DbSetOrder(_aAlias[_nN,2])                                             
			DbGoto(_aAlias[_nN,3])                                                 
		Next                                                                     
		RestArea(_aArea)                                                         
	Endif                                                                      
Return Nil   

************************************
Static Function fCarrega()
************************************
*
*

Local cQuery := ""

aListBox1 := {}

cQuery := "SELECT DISTINCT C8_FILIAL, C8_PRODUTO, C8_QUANT, C8_NUMSC, C8_ITEMSC, C8_ZTIPOPR, B1_ZREF1, B1_DESC, C8_ITEM"
cQuery += " FROM " + RetSqlName("SC8") + " SC8, " + RetSqlName("SB1") + " SB1 " 
cQuery += " WHERE C8_PRODUTO = B1_COD"
cQuery += " AND C8_NUM = '" + cZNumCot + "'"
cQuery += " AND C8_NUMPED = ' '"  // 20150609
cQuery += " AND SC8.D_E_L_E_T_ <> '*'"
cQuery += " AND SB1.D_E_L_E_T_ <> '*'"
cQuery += " ORDER BY C8_PRODUTO"

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBFOR",.T.,.T.) 

dbSelectArea("TRBFOR")
dbgoTop()

if !Eof("TRBFOR")

	While !Eof("TRBFOR") 
	
		Aadd(aListBox1,{.F.,"","","","","","","","",0,""})
		
		//"Empresa","Filial","Num.SC","Cod.Protheus","Produto","Descri��o","Marca","Aplica��o","Classifica��o";
		
		aListBox1[Len(aListBox1),01] := .F.
		aListBox1[Len(aListBox1),02] := SM0->M0_CODIGO
		aListBox1[Len(aListBox1),03] := TRBFOR->C8_FILIAL
		aListBox1[Len(aListBox1),04] := TRBFOR->C8_NUMSC
		aListBox1[Len(aListBox1),05] := TRBFOR->C8_PRODUTO
		aListBox1[Len(aListBox1),06] := TRBFOR->B1_ZREF1
		aListBox1[Len(aListBox1),07] := TRBFOR->B1_DESC
		aListBox1[Len(aListBox1),08] := TRBFOR->C8_ZTIPOPR 
		aListBox1[Len(aListBox1),09] := TRBFOR->C8_ITEMSC
		aListBox1[Len(aListBox1),10] := TRBFOR->C8_QUANT
		aListBox1[Len(aListBox1),11] := TRBFOR->C8_ITEM
		
		
		dbSelectArea("TRBFOR")
		dbSkip()
	
	enddo  

else
	Aadd(aListBox1,{.F.,"","","","","","",""})
endif
	
dbSelectArea("TRBFOR")
dbCloseArea("TRBFOR")   

oListBox1:SetArray( aListBox1 )

oListBox1:bLine := {|| { If(aListBox1[oListBox1:nAT,1],oOk,oNo),;
						 aListBox1[oListBox1:nAT,02],;
						 aListBox1[oListBox1:nAT,03],;
						 aListBox1[oListBox1:nAT,04],;
						 aListBox1[oListBox1:nAT,05],;
						 aListBox1[oListBox1:nAT,06],;
						 aListBox1[oListBox1:nAT,07],;
						 aListBox1[oListBox1:nAT,08]}}

oListBox1:Refresh()

return  

************************************
Static Function fConf()
************************************
*
*
Local nProMarc := 0
Local nItem    := 1

Local cFilInc   := ""
Local cFornInc  := ""
Local cLojaInc  := ""
Local cItemInc  := ""
Local cProposta := ""

For nXXCont := 1 To Len(aListBox1)
	if aListBox1[nXXCont,1]
		nProMarc++
	endif
Next

if nProMarc == 0
	ApMsgInfo("Escolha um produto para incluir...")
	return
endif

For nXXCont := 1 To Len(aListBox1)

	if aListBox1[nXXCont,1] 
	
		nItem := 1

		For XYYCont := 1 To Len(oGetDados1:aCols)
		
			if ! oGetDados1:aCols[XYYCont,Len(oGetDados1:aCols[XYYCont])]  
			   
			   If ! Empty(oGetDados1:aCols[XYYCont,1]) .And. ! Empty(oGetDados1:aCols[XYYCont,2] )
               
               cFilInc   := aListBox1[nXXCont,3] 
               cFornInc  := oGetDados1:aCols[XYYCont,1]
               cLojaInc  := oGetDados1:aCols[XYYCont,2] 
               cItemInc  := aListBox1[nXXCont,11] //StrZero(nItem,4)  
               cProposta := "01"

				   dbSelectArea("SC8")    
               DbSetOrder(1) // C8_FILIAL+C8_NUM+C8_FORNECE+C8_LOJA+C8_ITEM+C8_NUMPRO+C8_ITEMGRD
					DbSeek( cFilInc + cZNumCot + cFornInc + cLojaInc + cItemInc + cProposta , .T. )
						
					If ! Eof() .And. SC8->(C8_FILIAL+C8_NUM+C8_FORNECE+C8_LOJA+C8_ITEM+C8_NUMPRO) == cFilInc + cZNumCot + cFornInc + cLojaInc + cItemInc + cProposta
					   cProposta := StrZero( Val(SC8->C8_NUMPRO) + 1 , 2 )
					Endif
				   
				   if RecLock("SC8", .T.)
					   SC8->C8_FILIAL  := cFilInc
					   SC8->C8_NUM     := cZNumCot
	   			   SC8->C8_FORNECE := cFornInc 
   	            SC8->C8_LOJA    := cLojaInc      
					   SC8->C8_ITEM    := cItemInc   	            
                  SC8->C8_NUMPRO  := cProposta	            	
	               SC8->C8_ZHORA   := SubStr(Time(),1,5)
		 			   SC8->C8_ZUSER   := cXXCodUsr 
					   SC8->C8_EMISSAO := dDataBase 
					   SC8->C8_PRODUTO := aListBox1[nXXCont,5]
					   SC8->C8_QUANT   := aListBox1[nXXCont,10]
					   SC8->C8_ZQUANTIN:= aListBox1[nXXCont,10]
					   SC8->C8_NUMSC   := aListBox1[nXXCont,4]    
					   SC8->C8_ITEMSC  := aListBox1[nXXCont,09]    
					   SC8->C8_ZTIPOPR := aListBox1[nXXCont,08]    
					   SC8->C8_ZDESCRI := Posicione("SB1",1,xFilial("SB1")+aListBox1[nXXCont,5],"B1_DESC") 
					   SC8->C8_UM      := Posicione("SB1",1,xFilial("SB1")+aListBox1[nXXCont,5],"B1_UM")   
	    		      SC8->C8_ZSTATUS := "3"    
	    		      SC8->C8_ZEMP    := aListBox1[nXXCont,2] 
					   MsUnLock() 			
				   endif 
				Endif
				
				nItem := nItem + 1   
				
				dbSelectArea("SZ2") 
				cNumOcor := ""
				cNumOcor := GetSxENum("SZ2","Z2_NUMERO") 
				ConfirmSX8()
				
	 			dbSelectArea("SZ2")   
	 			
				if RecLock("SZ2", .T.)      
					SZ2->Z2_FILIAL   := aListBox1[nXXCont,3] 
					SZ2->Z2_NUMERO   := cNumOcor
					SZ2->Z2_CODIGO   := '002'
					SZ2->Z2_NUMSC    := aListBox1[nXXCont,4] 
					SZ2->Z2_ITEMSC   := aListBox1[nXXCont,09]
					SZ2->Z2_NUMCOT   := cZNumCot
					SZ2->Z2_PRODUTO  := aListBox1[nXXCont,5]
					SZ2->Z2_CODUSR   := cXXCodUsr
					SZ2->Z2_NOMEUSR  := UsrRetName(cXXCodUsr)
					SZ2->Z2_DATA     := DATE()
					SZ2->Z2_HORA     := TIME()
			    	SZ2->Z2_MOTIVO   := "GERA COTA��O"
			    	SZ2->Z2_EMAIL1   := ""
			    	SZ2->Z2_EMAIL2   := ""
			    	SZ2->Z2_EMAIL3   := ""
			    	SZ2->Z2_EMAIL4   := ""
			    	SZ2->Z2_EMAIL5   := ""
			 		MsUnLock()  
				Endif				    
			
			endif					
		
		Next
	
	endif

Next  

//Envia e-mail para cadas fornecedor com o endere�o informado
For nX := 1 to Len(oGetDados1:aCols)    
		
	If !oGetDados1:aCols[nX,Len(oGetDados1:aCols[nX])]        .And. ;
	   !Empty(oGetDados1:aCols[nX,1]) .And. ;
	   !Empty(oGetDados1:aCols[nX,2]) .And. ;
	   !Empty(oGetDados1:aCols[nX,4]) 
	
		MsAguarde( {|lEnd|u_AFATR05(cZNumCot,;
			oGetDados1:aCols[nX,1],;
			oGetDados1:aCols[nX,2],;
			Alltrim(oGetDados1:aCols[nX,4]),cZFilAux)},"Aguarde","Enviando e-mail... Aguarde... ",.T.)
	Endif
Next

oDlg:End()

return  

************************************
Static Function fTodos()
************************************
*
* 
Local nTodos := 1

For nTodos := 1 to Len(aListBox1)
	aListBox1[nTodos,1] := .T.
Next                            

return
