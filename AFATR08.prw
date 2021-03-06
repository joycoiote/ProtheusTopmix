#INCLUDE "MATR150.CH"
#INCLUDE "PROTHEUS.CH"
                                      
Static nSegundaUnid      

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR150  � Autor � Ricardo Berti		    � Data �31/07/2007���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Emissao das Cotacoes                                       ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � MATR150(void)                                              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function AFATR08(cNumCota,cFilAux)

Local oReport

//If FindFunction("TRepInUse") .And. TRepInUse()
	//������������������������������������������������������������������������Ŀ
	//�Interface de impressao                                                  �
	//��������������������������������������������������������������������������
	oReport:= ReportDef(cNumCota,cFilAux)
	oReport:PrintDialog() 
//Else
///	MATR150R3( cNumCota,cFilAux ) 
///	MsgStop("222")
//EndIf
                                               
Return


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � ReportDef� Autor � Ricardo Berti		    � Data �31/07/2007���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Emissao das Cotacoes                                       ���
�������������������������������������������������������������������������Ĵ��
���Parametros� nExp01: cNumCota = Cotacao a ser impressa                  ���
�������������������������������������������������������������������������Ĵ��
���Retorno   � oExpO1: Objeto do relatorio                                ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportDef(cNumCota,cFilAux)

Local oReport 
Local oSection1 
Local oSection2 
Local cTitle := STR0001	//"Emissao das cotacoes de compras"
Local cEmail,cEndEnt,cTel
Local cPerg, wNrel
// Verifica conteudo p/ Grupo Fornec. (001) e Loja (002)
//Local aTamSXG  := TamSXG("001")    //{6,"@!",6,20}
//Local aTamSXG2 := TamSXG("002")    //{2,"@!",2,4}
Local aTamSXG  := {6,"@!",6,20}
Local aTamSXG2 := {2,"@!",2,4}

Local cDescPro := ""
Local nItem    := 0

PRIVATE nomeprog:="MATR150"
wNrel  := "AFATR08"
//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01	     	  Do Numero                              �
//� mv_par02	     	  Ate o Numero 		                     �
//� mv_par03	     	  Do Fornecedor                          �
//� mv_par04              Ate o Fornecedor            	     	 �
//� mv_par05              Ate a data de validade      	   	     �
//� mv_par06              Campo Descricao do Produto             �
//� mv_par07              Endrre�o Fiscal                        �
//� mv_par08              Cidade - Estado                        �
//� mv_par09              Fax                                    �
//� mv_par10              Qual Unidade de Medida ?               �
//� mv_par11              Telefone                               �
//� mv_par12              Endereco de Entrega ?                  �
//� mv_par13              Endereco de e-mail  ?                  �
//����������������������������������������������������������������

If cNumCota == Nil
	cPerg := "MTR150"
Else
	cPerg := "MR150A"
EndIf
pergunte(cPerg,.F.)

If !Empty(cNumCota)
    cEmail       := mv_par09
    cEndEnt      := mv_par08
	cTel         := mv_par07
	nSegundaUnid := mv_par06		// Grupo MR150A
	mv_par09     := mv_par05
	mv_par08     := mv_par04
	mv_par07     := mv_par03
	mv_par06     := mv_par02
	mv_par05     := mv_par01
	nomeprog     := "MATA130"
	mv_par01     := cNumCota
	mv_par02     := cNumCota
	mv_par03     := "      "
	mv_par04     := "ZZZZZZ"
Else
	nSegundaUnid := mv_par10
	cTel         := mv_par11		// Grupo MTR150
    cEndEnt      := mv_par12
    cEmail       := mv_par13
EndIf

oReport := TReport():New(wNrel,cTitle,cPerg,{|oReport| ReportPrint(oReport,@cDescPro,cEmail,cEndEnt,cTel,@nItem,cNumCota,cFilAux)},STR0001+" "+STR0002) //"Relacao de Cotacoes"
oReport:SetPortrait()
oReport:HideHeader()			// Nao imprime cabecalho padrao do Protheus
oReport:HideFooter()			// Nao imprime rodape padrao do Protheus
oReport:HideParamPage()			// inibe impressao da pagina de parametros
oReport:SetTotalInLine(.F.)

//������������������������������������������������������������������������Ŀ
//�Criacao da secao utilizada pelo relatorio                               �
//�                                                                        �
//�TRSection():New                                                         �
//�ExpO1 : Objeto TReport que a secao pertence                             �
//�ExpC2 : Descricao da se�ao                                              �
//�ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   �
//�        sera considerada como principal para a se��o.                   �
//�ExpA4 : Array com as Ordens do relat�rio                                �
//�ExpL5 : Carrega campos do SX3 como celulas                              �
//�        Default : False                                                 �
//�ExpL6 : Carrega ordens do Sindex                                        �
//�        Default : False                                                 �
//�                                                                        �
//��������������������������������������������������������������������������
//������������������������������������������������������������������������Ŀ
//�Criacao da celulas da secao do relatorio                                �
//�                                                                        �
//�TRCell():New                                                            �
//�ExpO1 : Objeto TSection que a secao pertence                            �
//�ExpC2 : Nome da celula do relat�rio. O SX3 ser� consultado              �
//�ExpC3 : Nome da tabela de referencia da celula                          �
//�ExpC4 : Titulo da celula                                                �
//�        Default : X3Titulo()                                            �
//�ExpC5 : Picture                                                         �
//�        Default : X3_PICTURE                                            �
//�ExpC6 : Tamanho                                                         �
//�        Default : X3_TAMANHO                                            �
//�ExpL7 : Informe se o tamanho esta em pixel                              �
//�        Default : False                                                 �
//�ExpB8 : Bloco de c�digo para impressao.                                 �
//�        Default : ExpC2                                                 �
//�                                                                        �
//��������������������������������������������������������������������������

oSection1 := TRSection():New(oReport,STR0001,{"SC8","SM0","SA2"}) //"Emissao das cotacoes de compras"

oSection1:SetLineStyle()
oSection1:SetReadOnly()
oSection1:SetHeaderSection(.F.)	// Desabilita Impressao Cabecalho no Topo da Pagina
oSection1:SetNoFilter("SM0")
oSection1:SetNoFilter("SA2")
oSection1:SetCharSeparator("")

oSection2 := TRSection():New(oSection1,STR0002,{"SC8","SB1"})  //"Relacao de Cotacoes"
oSection2:SetNoFilter("SB1")

TRCell():New(oSection2,"ITEM"		,"SC8",STR0037,/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| StrZero(++nItem,4) })
TRCell():New(oSection2,"C8_PRODUTO","SC8",STR0036,,15,,) //"N/Vosso Codigo"
TRCell():New(oSection2,"DESCPROD"  ,"SB1",RetTitle("B1_DESC"),,50,, {|| cDescPro })
TRCell():New(oSection2,"C8_QUANT",  "SC8",,,,, {|| If(nSegundaUnid==2 .And. !Empty(SC8->C8_QTSEGUM),SC8->C8_QTSEGUM,SC8->C8_QUANT) })
TRCell():New(oSection2,"C8_UM",     "SC8",,,,, {|| If(nSegundaUnid==2 .And. !Empty(SC8->C8_QTSEGUM),SC8->C8_SEGUM,SC8->C8_UM) })
TRCell():New(oSection2,"CDADOS"    ,"   ",Iif(cPaisLoc<>"PER",STR0034,STR0040),,,,) //   {|| Replicate("_",Len(STR0034)) })  //"Val.Unitario    Valor Total    IPI   Valor do IPI  Prz(dias)"
TRCell():New(oSection2,"C8_DATPRF", "SC8",,,,,)

oSection2:Cell("DESCPROD"):SetLineBreak()
oSection2:Cell("CDADOS"):SetLineBreak() 
	
Return(oReport)


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrin� Autor � Ricardo Berti		    � Data �31/07/2007���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relat�rio                           ���
���          �ExpC1: Var. para montagem da descr. do produto			  ���
���          �ExpC2: e-mail digitado na pergunte						  ���
���          �ExpC3: end.entrega digitada na pergunte					  ���
���          �ExpC4: telefonte digitado na pergunte						  ���
���          �ExpN1: var.p/calculo do No.do item na impressao			  ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportPrint(oReport,cDescPro,cEmail,cEndEnt,cTel,nItem,cNumCota,cFilAux)

LOCAL oSection1 := oReport:Section(1)
LOCAL oSection2 := oReport:Section(1):Section(1)
LOCAL cCondicao:= ""
LOCAL cCotacao := ""
LOCAL cNumero  := ""
LOCAL cDtValid := ""
LOCAL cFornece := ""
LOCAL cLoja    := ""
LOCAL cDescri  := ""
LOCAL cContato := ""
LOCAL cVar     := ""
LOCAL cbCont   := 0
LOCAL cObs01   := ""
LOCAL cObs02   := ""
LOCAL cObs03   := ""
LOCAL cObs04   := ""
LOCAL nLinObs  := 0
LOCAL nX       := 0
LOCAL cEndere
LOCAL cCidEst
LOCAL cEnd
Local dEmissao := CtoD("")
Local nPrinted := 0
Local nPagina  := 0
Local nRegistro:= 0  
Local nTamCdPrd:= TamSX3("C7_PRODUTO")[1]
Local cFilEnt  := ""

If cNumCota == Nil
	cPerg := "MTR150"
Else
	cPerg := "MR150A"
EndIf
pergunte(cPerg,.F.)

If !Empty(cNumCota)
    cEmail       := mv_par09
    cEndEnt      := mv_par08
	cTel         := mv_par07
	nSegundaUnid := mv_par06		// Grupo MR150A
	mv_par09     := mv_par05
	mv_par08     := mv_par04
	mv_par07     := mv_par03
	mv_par06     := mv_par02
	mv_par05     := mv_par01
	nomeprog     := "MATA130"
	mv_par01     := cNumCota
	mv_par02     := cNumCota
	mv_par03     := "      "
	mv_par04     := "ZZZZZZ"
Else
	nSegundaUnid := mv_par10
	cTel         := mv_par11		// Grupo MTR150
    cEndEnt      := mv_par12
    cEmail       := mv_par13
EndIf

//������������������������������������������������������������������������Ŀ
//�Filtragem do relat�rio                                                  �
//��������������������������������������������������������������������������
dbSelectArea("SC8")
dbSetOrder(1)
                  
If oReport:nEnvironment == 2    
	oSection2:Cell("ITEM"):nSize 	    := 6
	oSection2:Cell("C8_PRODUTO"):nSize  := IIf(nTamCdPrd==15,22,22)
//	oSection2:Cell("C8_PRODUTO"):nSize  := IIf(nTamCdPrd==15,22,50)
	oSection2:Cell("DESCPROD"):nSize    := IIf(nTamCdPrd==15,30,10)
	oSection2:Cell("C8_QUANT"):nSize    := 16
	oSection2:Cell("C8_UM"):nSize       := 2
	oSection2:Cell("CDADOS"):nSize      := 55
	oSection2:Cell("C8_DATPRF"):nSize   := 18
EndIf  

//������������������������������������������������������������������������Ŀ
//�Transforma parametros Range em expressao Advpl                          �
//��������������������������������������������������������������������������
MakeAdvplExpr(oReport:uParam)

cCondicao := 'C8_FILIAL = "'+cFilAux+'".And.' 
cCondicao += 'C8_NUM >= "'+mv_par01+'".And. C8_NUM <="'+mv_par02+'".And.'
cCondicao += 'C8_FORNECE >= "'+mv_par03+'" .And. C8_FORNECE <="'+mv_par04+'".And.'	
cCondicao += 'DtoS(C8_VALIDA) <= "'+DtoS(mv_par05)+'".And.'
cCondicao += 'Empty(C8_NUMPED)'

oReport:Section(1):SetFilter(cCondicao,IndexKey())
	
TRPosition():New(oSection1,"SA2",1,{|| xFilial("SA2") + SC8->C8_FORNECE + SC8->C8_LOJA})

//�����������������������������������������������������������������������������������������Ŀ
//� Executa o CodeBlock com o PrintLine da Sessao 1 toda vez que rodar o oSection1:Init()   �
//�������������������������������������������������������������������������������������������
oReport:onPageBreak( { || nPagina++ , nPrinted := 0 , CabecCT(oReport,oSection1,nPagina,cNumCota,cEmail,cTel) })

//������������������������������������������������������������������������Ŀ
//�Inicio da impressao do fluxo do relat�rio                               �
//��������������������������������������������������������������������������
oReport:SetMeter(SC8->(LastRec()))

oSection2:Init()
dbSelectArea("SC8")

While !oReport:Cancel() .And. !SC8->(Eof())

	If oReport:Cancel()
		Exit
	EndIf
	
	cCotacao := SC8->C8_NUM  
	cFornece := SC8->C8_FORNECE
	cLoja    := SC8->C8_LOJA   

	cObs01   := " "
	cObs02   := " "
	cObs03   := " "
	cObs04   := " "
	nLinObs  := 0
	nItem    := 0
	//��������������������������������������������������������������Ŀ
	//� Dispara a cabec especifica do relatorio.                     �
	//����������������������������������������������������������������
	oReport:EndPage()

	nPagina  := 0
	nPrinted := 0
		
	While !oReport:Cancel() .And. !SC8->(Eof()) .And. SC8->C8_FILIAL+SC8->C8_NUM+SC8->C8_FORNECE+SC8->C8_LOJA == cFilAux+cCotacao+cFornece+cLoja
		
		If oReport:Cancel()
			Exit
		EndIf

		cContato := SC8->C8_CONTATO
		dEmissao := SC8->C8_EMISSAO

		oReport:IncMeter() 
		If oReport:Row() > oReport:LineHeight() * 100
			oReport:Box( oReport:Row(),010,oReport:Row() + oReport:LineHeight() * 3, 2290 )
			oReport:SkipLine()
			oReport:PrintText(STR0015,, 050 ) // Continua ....
			oReport:EndPage()
		EndIf

		cDescPro := ""
		dbSelectArea("SA5")
		dbSetOrder(1)
		If dbSeek(xFilial("SA5") + SC8->C8_FORNECE + SC8->C8_LOJA + SC8->C8_PRODUTO ) ;
			.And. AllTrim(mv_par06) == "A5_NOMPROD"
			cDescPro := Alltrim(A5_NOMPROD)
		EndIf
		dbSelectArea("SC8")
		If Empty(cDescPro)
			ImpDescr(@cDescPro,.T.,cFilAux)
		EndIf
		cFilEnt := SC8->C8_FILENT
		
		//��������������������������������������������������������������Ŀ
		//� Inicializacao da Observacao da Cotacao                       �
		//����������������������������������������������������������������
		If !EMPTY(SC8->C8_OBS) .And. nLinObs < 5
			nLinObs++
			cVar:="cObs"+StrZero(nLinObs,2)
			Eval(MemVarBlock(cVar),SC8->C8_OBS)
		Endif

		oSection2:PrintLine()
		nPrinted ++
		If !Empty(SA5->A5_CODPRF)
			oReport:PrintText( Replicate("_",Iif(cPaisLoc<>"PER",Len(STR0034),Len(STR0040))), oReport:Row(), oSection2:Cell("CDADOS"):ColPos() )  //"Val.Unitario    Valor Total    IPI   Valor do IPI  Prz(dias)"
			oReport:PrintText( SA5->A5_CODPRF,oReport:Row(),oSection2:Cell("C8_PRODUTO"):ColPos() )
			oReport:SkipLine()
  		Else
			oReport:PrintText( Replicate("_",Iif(cPaisLoc<>"PER",Len(STR0034),Len(STR0040))),, oSection2:Cell("CDADOS"):ColPos() )  //"Val.Unitario    Valor Total    IPI   Valor do IPI  Prz(dias)"
		EndIf
		nPrinted ++

		dbSelectArea("SC8")
		dbSkip()
	EndDo

	oReport:SkipLine()
	
	If nLinObs > 0
		//��������������������������������������������������������������Ŀ
		//� Inicializar campos de Observacoes.                           �
		//����������������������������������������������������������������
		If Empty(cObs02)
			If Len(cObs01) > 50
				cObs 	:= cObs01
				cObs01:= Substr(cObs,1,50)
				For nX := 2 To 4
					cVar  := "cObs"+StrZero(nX,2)
					&cVar := Substr(cObs,(50*(nX-1))+1,50)
				Next
			EndIf
		Else
			cObs01:= Substr(cObs01,1,IIf(Len(cObs01)<50,Len(cObs01),50))
			cObs02:= Substr(cObs02,1,IIf(Len(cObs02)<50,Len(cObs01),50))
			cObs03:= Substr(cObs03,1,IIf(Len(cObs03)<50,Len(cObs01),50))
			cObs04:= Substr(cObs04,1,IIf(Len(cObs04)<50,Len(cObs01),50))
		EndIf
	EndIf

	If oReport:Row() > oReport:LineHeight() * 70

		dbSelectArea("SC8")
		dbSkip(-1)  // condicao onde ja imprimiu tudo mas o rodape sera' impresso em nova pagina
			
		oReport:Box( oReport:Row(),010,oReport:Row() + oReport:LineHeight() * 3, 2290 )
		oReport:SkipLine()
		oReport:PrintText(STR0015,, 050 ) // Continua ....
			
		//��������������������������������������������������������������Ŀ
		//� Dispara a cabec especifica do relatorio.                     �
		//����������������������������������������������������������������
		oReport:EndPage()
			
		oSection2:Cell("ITEM"):Hide()
		oSection2:Cell("C8_PRODUTO"):Hide()
		oSection2:Cell("DESCPROD"):Hide()
		oSection2:Cell("C8_QUANT"):Hide()
		oSection2:Cell("C8_UM"):Hide()
		oSection2:Cell("CDADOS"):Hide()
		oSection2:Cell("C8_DATPRF"):Hide()
		oSection2:PrintLine()
		oSection2:Cell("ITEM"):Show()
		oSection2:Cell("C8_PRODUTO"):Show()
		oSection2:Cell("DESCPROD"):Show()
		oSection2:Cell("C8_QUANT"):Show()
		oSection2:Cell("C8_UM"):Show()
		oSection2:Cell("CDADOS"):Show()
		oSection2:Cell("C8_DATPRF"):Show()
		
		dbSelectArea("SC8")
		dbSkip()
			
	EndIf

	oReport:Box( 2480 ,  010 , 3012 , 2290 ) // Box do rodape'

	oReport:Line( 2660,  010 , 2660 , 2290 ) // Completa o Box Observacoes
	oReport:Line( 2660,  840 , 3012 ,  840 ) // Completa o Box do Local de Entrega
	oReport:Line( 2660, 1600 , 3012 , 1600 ) // Completa o Box do Sub Total

	oReport:Line( 2870 , 010 , 2870 , 2290 ) // Completa o Box da Alcada

    oReport:PrintText(" ",2490,020)	// Necessario para posicionar Row() para a impressao do Rodape
    
    oReport:PrintText(STR0032,,020)  //Observacoes :
	oReport:PrintText(cObs01,,020 )
	oReport:PrintText(cObs02,,020 )
	oReport:PrintText(cObs03,,020 )
	oReport:PrintText(cObs04,,020 )
 
	//��������������������������������������������������������������Ŀ
	//� Acessar o Endereco para Entrega do Arquivo de Empresa SM0.   �
	//����������������������������������������������������������������
	dbSelectArea("SM0")
	dbSetOrder(1)   && forca o indice na ordem certa
	nRegistro := Recno()
	MsSeek(SUBS(cNumEmp,1,2)+CFilEnt)

	oReport:SkipLine()
	oReport:PrintText( + STR0018,oReport:Row(),  020 ) //"Local de Entrega:"
	oReport:PrintText( + STR0019,oReport:Row(),  850 ) //"Sub Total"
	oReport:PrintText( + STR0020,oReport:Row(), 1610 ) //"Condicao de Pagamento"
    //��������������������������������������������������������������������Ŀ
    //� Imprime o End de Entrega do SM0 somente quando cEndEnt  == " "     �
    //����������������������������������������������������������������������
	If Empty(cEndEnt)
		cEnd := If( Empty(SM0->M0_ENDENT), " O mesmo ", SM0->M0_ENDENT)
	Else
		cEnd := cEndEnt // imprime o endereco digitado na pergunte
	Endif
	Go nRegistro

	oReport:SkipLine()
	oReport:PrintText( + cEnd	,oReport:Row(), 020 )
	oReport:PrintText( + STR0021,oReport:Row(), 850 ) //"Descontos "

	oReport:SkipLine()
	oReport:PrintText( + STR0022,oReport:Row(), 020 ) //"Local de Cobranca:"
	oReport:PrintText( + Iif(cPaisLoc<>"PER",STR0023,STR0039),oReport:Row(), 850 ) //"Total do IPI"

	cEnd := If(Empty(SM0->M0_ENDCOB),Iif(Empty(SM0->M0_ENDENT),"O mesmo",SM0->M0_ENDENT),SM0->M0_ENDCOB)
	oReport:SkipLine()
	oReport:PrintText( + cEnd	,oReport:Row(),  020 )
	oReport:PrintText( + STR0024,oReport:Row(),  850 )	 //"Frete"
	oReport:PrintText( + STR0025,oReport:Row(), 1610 )	 //"Condicao de Reajuste"

	oReport:SkipLine()
	oReport:PrintText( + STR0026,oReport:Row(),  020 )	 //"Contato no Fornecedor"

	oReport:SkipLine()
	oReport:PrintText( + cContato ,oReport:Row(),  020 )
	oReport:PrintText( + STR0027+Replicate(".",11)  ,oReport:Row(),  850 )	 //"TOTAL DO PEDIDO"
	oReport:Line( oReport:Row(), 840 , oReport:Row(), 1600 ) // Linha do Total do Pedido

	oReport:SkipLine()
	oReport:SkipLine()
	oReport:PrintText( + STR0028,oReport:Row(),  020 )	 //"Alcada 1"
	oReport:PrintText( + STR0029,oReport:Row(),  850 )	 //"Alcada 2"
	oReport:PrintText( + STR0030 +" "+Dtoc(dEmissao) ,oReport:Row(), 1610)	 //"Emitido em :"

	dbSelectArea("SC8")

Enddo
oSection2:Finish()

dbSelectArea("SC8")
Set Filter To
dbSetOrder(1)

Return NIL           


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR150R3� Autor � Claudinei M. Benzi    � Data � 05/06/92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Emissao das Cotacoes                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
��� ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ���
�������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR  � DATA   � BOPS �  MOTIVO DA ALTERACAO                   ���
�������������������������������������������������������������������������Ĵ��
��� Edson  M.    �04/11/98�xxxxxx� Acerto no lay-out p/ o ano 2000.       ���
��� Bruno        �14/12/98�melhor� Acerto na impressao do STR0031.        ���
��� Edson   M.   �30/03/99�XXXXXX�Passar o tamanho na SetPrint.           ���
��� Patricia Sal.�21/12/99�XXXXXX�Acerto Lay-Out, Fornec. com 20 pos.e Lj.���
���              �        �      �com 4 pos.                              ���
��� Patricia Sal.�08/05/00�003907�Aumentar a Pict. do campo Quantidade.   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Matr150R3(cNumCota)
//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
LOCAL wnrel
LOCAL cDesc1:=STR0001	//"Emissao das cotacoes de compras"
LOCAL cDesc2:=""
LOCAL cDesc3:=" "
LOCAL Tamanho:="M"
LOCAL cTel   :=""
LOCAL cEndEnt:=""
LOCAL cEmail :=""

PRIVATE titulo:=STR0002	//"Relacao de Cotacoes"
PRIVATE aReturn := { STR0003, 1,STR0004, 2, 2, 1, "",0 }		//"Zebrado"###"Administracao"
PRIVATE nomeprog:="MATR150",nLastKey := 0
PRIVATE cString :="SC8"

cPerg  :="MTR150"
wnrel  := "AFATR08"
//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01	     	  Do Numero                              �
//� mv_par02	     	  Ate o Numero 		                     �
//� mv_par03	     	  Do Fornecedor                          �
//� mv_par04              Ate o Fornecedor            	     	 �
//� mv_par05              Ate a data de validade      	   	     �
//� mv_par06              Campo Descricao do Produto             �
//� mv_par07              Endere�o Fiscal                        �
//� mv_par08              Cidade - Estado                        �
//� mv_par09              Fax                                    �
//� mv_par10              Qual Unidade de Medida ?               �
//� mv_par11              Telefone                               �
//� mv_par12              Endereco de Entrega ?                  �
//� mv_par13              Endereco de e-mail  ?                  �
//����������������������������������������������������������������

If cNumCota == Nil
	pergunte("MTR150",.F.)
Else
	cPerg := "MR150A"
	Pergunte("MR150A",.F.)
EndIf

wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho)

If nLastKey = 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey = 27
	Set Filter To
	Return
Endif
If !Empty(cNumCota)
    cEmail       := mv_par09
    cEndEnt      := mv_par08
	cTel         := mv_par07
	nSegundaUnid := mv_par06		// Grupo MR150A
	mv_par09     := mv_par05
	mv_par08     := mv_par04
	mv_par07     := mv_par03
	mv_par06     := mv_par02
	mv_par05     := mv_par01
	nomeprog     := "MATA130"
	mv_par01     := cNumCota
	mv_par02     := cNumCota
	mv_par03     := "      "
	mv_par04     := "ZZZZZZ"
Else
	nSegundaUnid := mv_par10
	cTel         := mv_par11		// Grupo MTR150
    cEndEnt      := mv_par12
    cEmail       := mv_par13
EndIf

RptStatus({|lEnd| R150Imp(@lEnd,wnrel,cString,@cTel,cEndEnt,cEmail)},Titulo)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � R150IMP  � Autor � Cristina M. Ogura     � Data � 10.11.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do Relatorio                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR150                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function R150Imp(lEnd,wnrel,cString,cTel,cEndEnt,cEmail)

// Verifica conteudo p/ Grupo Fornec. (001) e Loja (002)
LOCAL aTamSXG  := TamSXG("001")
LOCAL aTamSXG2 := TamSXG("002")
LOCAL cNumero  := ""
LOCAL cDtValid := ""
LOCAL cFornece := ""
LOCAL cLoja    := ""
LOCAL cDescri  := ""
LOCAL cabec1   := ""
LOCAL cabec2   := ""
LOCAL cabec3   := ""
LOCAL cContato := ""
LOCAL cObs01   := ""
LOCAL cObs02   := ""
LOCAL cObs03   := ""
LOCAL cObs04   := ""
LOCAL cVar     := ""
LOCAL cbCont   := 0
LOCAL nItem    := 0
LOCAL nLinObs  := 0
LOCAL dEmissao
Local nX       := 0
Local nRegistro:= 0
Local lC8FilEn := .F.
Local cFilEnt  := ""
LOCAL cFax

limite   := 132
li       := 80
m_pag    := 1
nPag     := 0
//�������������������������������������������������������������������Ŀ
//� Inicializa os codigos de caracter Comprimido/Normal da impressora �
//� Faz manualmente porque nao chama a funcao Cabec()                 �
//���������������������������������������������������������������������
@ 0,0 PSAY AvalImp(Limite)

//��������������������������������������������������������������Ŀ
//� Pesquisa Numero da Cotacao                                   �
//����������������������������������������������������������������
dbSelectArea("SC8")
dbSetOrder(1)
Set SoftSeek On
dbSeek(cFilAux+mv_par01)
Set SoftSeek Off

SetRegua(RecCount())

While cFilAux = C8_FILIAL .And. C8_NUM >= mv_par01 .And. C8_NUM <= mv_par02 .And. !Eof()
	
	IncRegua()
	
	//��������������������������������������������������������������Ŀ
	//� Verifica Fornecedor                                          �
	//����������������������������������������������������������������
	IF C8_FORNECE < mv_par03 .OR. C8_FORNECE > mv_par04
		dbSkip()
		Loop
	Endif
	
	//��������������������������������������������������������������Ŀ
	//� Verifica Data de Validade ou se ja tem pedido feito          �
	//����������������������������������������������������������������
	IF C8_VALIDA > mv_par05 .OR. !Empty(C8_NUMPED)
		dbSkip()
		Loop
	Endif
	
	cContato := SC8->C8_CONTATO
	dEmissao := SC8->C8_EMISSAO
	
	IF li > 58
		nPag ++
		@0 ,  0 PSAY STR0005	//"PREZADOS SENHORES."
		@ 00,70 PSAY STR0006 + SC8->C8_NUM + Space(5) + STR0007 + DTOC(SC8->C8_VALIDA) + Space(6) + STR0035 + STRZERO(nPag,4) 		//"COTACAO N. "###" Vencimento "###"Pagina  "
		dbSelectArea("SA2")
		dbSeek(xFilial("SA2")+SC8->C8_FORNECE+SC8->C8_LOJA)
		If aTamSXG[1] != aTamSXG[3]
			@1 ,  0 PSAY SubStr(A2_NOME,1,25)+" ("+A2_COD+" - "+A2_LOJA+")"
		Else
			@1 ,  0 PSAY SubStr(A2_NOME,1,40)+" ("+A2_COD+" - "+A2_LOJA+")"
		Endif
		@1 , 58 PSAY "|"
		@2 ,  0 PSAY A2_END
		@2 , 58 PSAY "| " + STR0008	//"Por favor queira referenciar este numero para quaisquer troca de"
		@3 ,  0 PSAY A2_BAIRRO
		@3 , 58 PSAY "| " + STR0009	//"informacoes referentes a esta cotacao."
		@4 ,  0 PSAY STR0010	+A2_DDD+" "+Substr(SA2->A2_TEL,1,15)		//"Fone: "
		@4 , 58 PSAY "|"+Space(28)+STR0011		//"Atenciosamente."
		@5 ,  0 PSAY STR0012+A2_DDD+" "+SA2->A2_FAX			//"Fax : "
		@5 , 58 PSAY "| "+ SM0->M0_NOMECOM
		
		cEndere	:= Iif(Empty(MV_PAR07), Iif(Empty(SM0->M0_ENDENT),SM0->M0_ENDCOB,SM0->M0_ENDENT), MV_PAR07)
		cCidEst	:= Iif(Empty(MV_PAR08), Iif(Empty(SM0->M0_CIDENT+SM0->M0_ESTENT), SM0->M0_CIDCOB + " " + SM0->M0_ESTCOB,  SM0->M0_CIDENT + " " + SM0->M0_ESTENT),MV_PAR08)
		cFax	:= Iif(Empty(MV_PAR09), SM0->M0_FAX, MV_PAR09)
		cTel    := Iif(Empty(cTel), SM0->M0_TEL, cTel)
		@6 , 58 PSAY "| "+ cEndere
		@7 ,  0 PSAY STR0013	//"Solicitamos de V Sas. cotacao de precos para os produtos"
		@7 , 58 PSAY "| "+ cCidEst
		@8 ,  0 PSAY STR0014	//"discriminados conforme os padroes abaixo estabelecidos:"
		@8 , 58 PSAY "| "+ STR0010 + cTel +	 "  "+STR0012	 + cFax		//"Fone : " "Fax : "
		@9 , 58 PSAY "| "+ STR0033 + " " + cEmail // "E-mail :"
		@10,  0 PSAY __PrtThinLine()
		@11,  0 PSAY Iif(cPaisLoc<>"PER",STR0016,STR0038)	//"ITM   N/Vosso Codigo Descricao da Mercadoria        Quantidade UN Valor Unitario      Valor Total IPI  Valor do IPI Pz e Dt Prev Entrg"
		@12,  0 PSAY Replicate("-", 4)
		@12,  5 PSAY Replicate("-",15)
		@12, 21 PSAY Replicate("-",30)
		@12, 52 PSAY Replicate("-",11)
		@12, 64 PSAY Replicate("-", 2)
		@12, 67 PSAY Replicate("-",13)
		@12, 81 PSAY Replicate("-",14)
		@12, 96 PSAY Replicate("-", 3)
		@12,100 PSAY Replicate("-",13)
		@12,114 PSAY Replicate("-",18)
		li:=12
		dbSelectArea("SC8")
		cNumero  := C8_NUM
		cFornece := C8_FORNECE
		cLoja    := C8_LOJA
		cDtValid := DTOC(SC8->C8_VALIDA) 
	Endif
	
	cObs01   := " "
	cObs02   := " "
	cObs03   := " "
	cObs04   := " "
	nLinObs  := 0
	nItem    := 0
	
	While !Eof() .And. C8_NUM == cNumero .And. cFornece == C8_FORNECE .And. C8_LOJA == cLoja
		IF li > 58
			li ++
			li ++
			nPag ++
			@ li,00 PSAY Replicate("-",limite-Len(STR0015))+STR0015 //" Continua ..."
			@ 00,00 PSAY STR0017+Replicate("-",53)		//"Continuacao ..."
			@ 00,70 PSAY STR0006 + cNumero + STR0007 + cDtValid + Space(13) + STR0035 + STRZERO(nPag,4) 		//"COTACAO N. "###" Vencimento "###"Pagina  "
			li := 1
		Endif
		
		IncRegua()
		
		li++
		nItem++
		@li,  0 PSAY StrZero(nItem,4)
		@li,  5 PSAY C8_PRODUTO
		ImpDescr()
		cFilEnt := SC8->C8_FILENT
		
		//��������������������������������������������������������������Ŀ
		//� Inicializacao da Observacao da Cotacao                       �
		//����������������������������������������������������������������
		If !EMPTY(SC8->C8_OBS) .And. nLinObs < 5
			nLinObs++
			cVar:="cObs"+StrZero(nLinObs,2)
			Eval(MemVarBlock(cVar),SC8->C8_OBS)
		Endif
		
		dbSelectArea("SC8")
		dbSkip()
	EndDo
	
	//��������������������������������������������������������������Ŀ
	//� Acessar o Endereco para Entrega do Arquivo de Empresa SM0.   �
	//����������������������������������������������������������������
	lC8FilEnt := .F.
	If SC8->(Eof()) .Or. cFilEnt != SC8->C8_FILENT
		dbSkip(-1)        // Para ter Certeza que nao e Eof() ou trocou a filial
		lC8FilEnt := .T.  // de Entrega
	Endif
	
	dbSelectArea("SM0")
	dbSetOrder(1)   && forca o indice na ordem certa
	nRegistro := Recno()
	dbSeek(SUBS(cNumEmp,1,2)+SC8->C8_FILENT)
	
	If li > Iif(nLinObs > 0,45,50)
		li ++
		li ++
		nPag ++
		@ li,00 PSAY Replicate("-",limite-Len(STR0015))+STR0015	//" Continua ..."
		@ 00,00 PSAY STR0017+Replicate("-",53)		//"Continuacao ..."
		@ 00,70 PSAY STR0006 + cNumero + STR0007 + cDtValid + Space(13) + STR0035 + STRZERO(nPag,4) 		//"COTACAO N. "###" Vencimento "###"Pagina  "
		li := 1
	Endif
	If lC8FilEnt .and. !SC8->(Eof())
		SC8->(dbSkip())
	Endif
	
	If nLinObs > 0
		//��������������������������������������������������������������Ŀ
		//� Inicializar campos de Observacoes.                           �
		//����������������������������������������������������������������
		If Empty(cObs02)
			If Len(cObs01) > 50
				cObs 	:= cObs01
				cObs01:= Substr(cObs,1,50)
				For nX := 2 To 4
					cVar  := "cObs"+StrZero(nX,2)
					&cVar := Substr(cObs,(50*(nX-1))+1,50)
				Next
			EndIf
		Else
			cObs01:= Substr(cObs01,1,IIf(Len(cObs01)<50,Len(cObs01),50))
			cObs02:= Substr(cObs02,1,IIf(Len(cObs02)<50,Len(cObs01),50))
			cObs03:= Substr(cObs03,1,IIf(Len(cObs03)<50,Len(cObs01),50))
			cObs04:= Substr(cObs04,1,IIf(Len(cObs04)<50,Len(cObs01),50))
		EndIf
		
		li:=45
		@ li,000 PSAY __PrtThinLine()
		li++
		@ li,000 PSAY STR0032	 //Observacoes :
		@ li,054 PSAY "|"
		li++
		@ li,000 PSAY cObs01
		@ li,054 PSAY "|"
		li++
		@ li,000 PSAY cObs02
		@ li,054 PSAY "|"
		li++
		@ li,000 PSAY cObs03
		@ li,054 PSAY "|"
		li++
		@ li,000 PSAY cObs04
		@ li,054 PSAY "|"		
	Else
		li:=50
	Endif
	
	li++
	@li,  0 PSAY __PrtThinLine()
	li++
	@li,  0 PSAY STR0018			//"Local de Entrega:"
	@li, 47 PSAY "|  "+STR0019		//"Sub Total"
	@li, 97 PSAY "| "+STR0020		//"Condicao de Pagamento"
	li++
    //��������������������������������������������������������������������Ŀ
    //� Imprime o End de Entrega do SM0 somente quando cEndEnt  == " "     �
    //����������������������������������������������������������������������
    If Empty(cEndEnt)
	   @li,  0 PSAY IIf( Empty(SM0->M0_ENDENT), " O mesmo ", SM0->M0_ENDENT )
    Else
       @li,  0 PSAY cEndEnt        
    EndIf
	@li, 47 PSAY "|  "+STR0021		//"Descontos "
	@li, 97 PSAY "|"
	Go nRegistro
	dbSelectArea("SC8")
	
	li++
	@li,  0 PSAY STR0022			//"Local de Pagamento:"
	@li, 47 PSAY "|  "+Iif(cPaisLoc<>"PER",STR0023,STR0039)		//"Total do IPI"
	@li, 97 PSAY "|"
	
	li++
	@li,  0 PSAY Iif(Empty(SM0->M0_ENDCOB),Iif(Empty(SM0->M0_ENDENT),"O mesmo",SM0->M0_ENDENT),SM0->M0_ENDCOB)
	@li, 47 PSAY "|  "+STR0024		//"Frete"
	@li, 97 PSAY "| "+STR0025		//"Condicao de Reajuste"
	
	li++
	@li,  0 PSAY STR0026	 		//"Contato no Fornecedor"
	@li, 47 PSAY "|"+Replicate("-",23)
	@li, 97 PSAY "|"
	
	li++
	@li,  0 PSAY cContato
	@li, 47 PSAY "|  "+STR0027 + Replicate(".",11)   //"TOTAL DO PEDIDO"
	@li, 97 PSAY "|"
	
	li++
	@li,  0 PSAY __PrtThinLine()
	
	li++
	@li,  0 PSAY STR0028		//"Alcada 1"
	@li, 28 PSAY "| "+STR0029	//"Alcada 2"
	@li,108 PSAY STR0030		//"Emitido em :"
	@li,121 PSAY dEmissao
	
	li++
	@li, 0  PSAY __PrtThinLine()
	
	dbSelectArea("SC8")
	li := 80
	nPag := 0
EndDo

dbSelectArea("SC8")
Set Filter To
dbSetOrder(1)

dbSelectArea("SA5")
dbSetOrder(1)

//��������������������������������������������������������������Ŀ
//� Se em disco, desvia para Spool                               �
//����������������������������������������������������������������
If aReturn[5] = 1    // Se Saida para disco, ativa SPOOL
	Set Printer To
	Commit
	OurSpool(wnrel)
Endif

MS_FLUSH()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �ImpValores� Autor � Jose Lucas            � Data � 19.07.93 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprimir Valores da Cotacao.	  							  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ImpValores(Void) 		                        		  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� 					                    					  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MatR150                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ImpValores()

dbSelectArea("SC8")

If nSegundaUnid == 2 .And. !Empty(SC8->C8_QTSEGUM)
	@li, 52 PSAY  SC8->C8_QTSEGUM Picture "99999999.99"
	@li, 64 PSAY  SC8->C8_SEGUM
Else
	@li, 52 PSAY  SC8->C8_QUANT Picture "99999999.99"
	@li, 64 PSAY  SC8->C8_UM
Endif

@li,119 PSAY  STR0031	//"dias"
@li,124 PSAY  SC8->C8_DATPRF
li++

dbSelectArea("SC8")
Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � ImpDescr � Autor � Jose Lucas            � Data � 19.07.93 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Montagem e Impressao(R3) da descricao do Produto.	 	  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ImpDescr(ExpC1,ExpL1)	                     			  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = var. para ser atualizada com a descricao do produto���
���          � ExpL1 = Se .T. = chamado do relatorio Release 4			  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MatR150                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ImpDescr(cDescri,lTReport,cFilAux1)

Local nBegin  := 0
Local nLinha  := 0

DEFAULT cDescri   := ""
DEFAULT lTReport  := .F.
DEFAULT cFilAux1  := xFilial("SC1")

If Empty(mv_par06)
	mv_par06 := "B1_DESC"
EndIf

//��������������������������������������������������������������Ŀ
//� Impressao da descricao cientifica do Produto.                �
//����������������������������������������������������������������
If AllTrim(mv_par06) == "B5_CEME"
	dbSelectArea("SB5")
	dbSetOrder(1)
	If dbSeek(xFilial("SB5")+SC8->C8_PRODUTO)
		cDescri := Alltrim(B5_CEME)
	EndIf
ElseIf AllTrim(mv_par06) == "A5_NOMPROD" .And. !lTReport
	dbSelectArea("SA5")
	dbSetOrder(1)
	If dbSeek(xFilial("SA5")+SC8->C8_FORNECE+SC8->C8_LOJA+SC8->C8_PRODUTO)
		cDescri := Alltrim(A5_NOMPROD)
	EndIf
EndIf

//��������������������������������������������������������������Ŀ
//� Impressao da descricao do produto do arquivo de Cotacoes.    �
//����������������������������������������������������������������
If AllTrim(mv_par06) == "C1_DESCRI" // B1_DESC
	dbSelectArea("SC1")
	dbSetOrder(1)
	If dbSeek(cFilAux1+SC8->C8_NUMSC+SC8->C8_ITEMSC)
		cDescri := Alltrim(C1_DESCRI)
	Endif
EndIf

//��������������������������������������������������������������Ŀ
//� Impressao da descricao do Produto SB1.		         		 �
//����������������������������������������������������������������
dbSelectArea("SB1")
dbSeek(xFilial("SB1")+SC8->C8_PRODUTO)
If Empty(cDescri)
	cDescri := Alltrim(B1_DESC)
EndIf
cDescri := cDescri + If(!Empty(SB1->B1_ZREF1)," Ref - " + SB1->B1_ZREF1,"")
dbSelectArea("SC8")

If !lTReport
	nLinha:= MLCount(cDescri,30)
	@ li,021 PSAY MemoLine(cDescri,30,1)
	ImpValores()
	For nBegin := 2 To nLinha
		@ li,021 PSAY Memoline(cDescri,30,nBegin)
	    If nBegin == 2
	    	@ li,067 PSAY Replicate("-",51)
	    EndIf
	    li++
	Next nBegin

	dbSelectArea("SA5")
	dbSetOrder(2)
	If dbSeek(xFilial("SA5")+SC8->C8_PRODUTO+SC8->C8_FORNECE+SC8->C8_LOJA)
		If !Empty(SA5->A5_CODPRF)
			@li,3 PSAY Alltrim(SA5->A5_CODPRF)
		EndIf
	Endif
	
	If nLinha < 2
	   	@ li,067 PSAY Replicate("-",51)
	EndIf
EndIf
	
Return Nil

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �CabecCT   � Autor � Ricardo Berti		    � Data �31/07/2007���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Emissao do Cotacao                                         ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � CabecCT(ExpO1,ExpO2,ExpN1,ExpC1)	                          ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpO1 = Objeto oReport                      	              ���
���          � ExpO2 = Objeto da secao1 com o cabec                       ���
���          � ExpN2 = Numero de Pagina                                   ���
���          � ExpC1 = Numero da Cotacao                                  ���
���          � ExpC2 = email                                              ���
���          � ExpC3 = telefone                                           ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
 �����������������������������������������������������������������������������
/*/
Static Function CabecCT(oReport,oSection1,nPagina,cNumCota,cEmail,cTel)
Local aTamSXG  := TamSXG("001")

Default cNumCota := ""

oSection1:Init()

oReport:Box(  010 , 010 , 380 , 2290 )  // Boxes do cabecalho
oReport:Line( 010 , 840 , 380 , 0840 )

oReport:PrintText( If(nPagina > 1,("- "+STR0017)," "),,020 )	  	//"Continuacao"
oReport:PrintText( + STR0006 + SC8->C8_NUM + Space(20) + ; 	// "COTACAO N. "
	STR0007 + DTOC(SC8->C8_VALIDA) + Space(20) + STR0035 + StrZero(nPagina,4),,940)  //" Vencimento "###"Pagina  "

oSection1:PrintLine()

oReport:PrintText(STR0005,120,020) // "PREZADOS SENHORES."

oReport:PrintText(SubStr(SA2->A2_NOME,1,If(aTamSXG[1] != aTamSXG[3],25,40))+" ("+SA2->A2_COD+" - "+SA2->A2_LOJA+")",120,020)
oReport:PrintText(STR0008,120,890) //"Por favor queira referenciar este numero para quaisquer troca de"

oReport:PrintText(SA2->A2_END,150,020)
oReport:PrintText(STR0009,150,890) //"informacoes referentes a esta cotacao."

oReport:PrintText(AllTrim(SA2->A2_BAIRRO + "  " + SA2->A2_MUN + " - " + SA2->A2_EST),180,020)
oReport:PrintText(Space(30) + STR0011,180,890) //"Atenciosamente."

oReport:PrintText(STR0010 + SA2->A2_DDD+" " + SA2->A2_TEL,210,020) //"Fone: "
oReport:PrintText(SM0->M0_NOMECOM,210,890)

oReport:PrintText(STR0012 + SA2->A2_DDD+" " + SA2->A2_FAX,240,020) //"Fax : "
oReport:PrintText(If(Empty(MV_PAR07), If(Empty(SM0->M0_ENDENT),SM0->M0_ENDCOB,SM0->M0_ENDENT),MV_PAR07),240,890)

oReport:PrintText(Space(57),270,020)
oReport:PrintText(If(Empty(MV_PAR08), If(Empty(SM0->M0_CIDENT+SM0->M0_ESTENT), SM0->M0_CIDCOB + " " + SM0->M0_ESTCOB,  SM0->M0_CIDENT + " " + SM0->M0_ESTENT),MV_PAR08),270,890)

oReport:PrintText(STR0013,300,020) //"Solicitamos de V Sas. cotacao de precos para os produtos"
oReport:PrintText(STR0010 + If(Empty(cTel), SM0->M0_TEL, cTel)+ "   " + STR0012 + If(Empty(MV_PAR09), SM0->M0_FAX, MV_PAR09),300,890) //"Fone: "### //"Fax : "

oReport:PrintText(STR0014,330,020) //"discriminados conforme os padroes abaixo estabelecidos:"
oReport:PrintText(STR0033 + " " + cEmail,330,890) //"E-mail :" 

oReport:PrintText(Space(10),360,020)

oSection1:PrintLine()
oReport:SkipLine()

oSection1:Finish()

Return NIL
