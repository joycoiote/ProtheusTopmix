#INCLUDE "rwmake.ch"
#INCLUDE "Topconn.ch"

/*
+----------+-----------+----------+-------------------------+------+-----------+
|Programa  | RPT0001   | Autor    | Max Rocha               |Data  |29.03.2012 |
+----------+-----------+----------+-------------------------+------+-----------+
|Descricao | Pedidos em Aberto - Fatura de Servi�os                            |
+----------+-------------------------------------------------------------------+
| USO      | Exclusivo da TOPMIX Engenharia                                    |
+----------+-------------------------------------------------------------------+
|Autor     | Data      | Descricao                                             |
+----------+-----------+-------------------------------------------------------+
*/

User Function RPT001()
****************************************************************************************
* Monta Tela Padr�o de Impress�es
*
*****

//Define Variaveis                                                        
Local cTitulo := "Pedidos Faturados/N�o Faturados"
Local cDesc1  := OemToAnsi("Ser� impresso de acordo com os parametros solicitados pelo")
Local cDesc2  := OemToAnsi("usuario.") 
Local cDesc3  := OemToAnsi("") 
Local cString := "SC5"  	// Alias utilizado na Filtragem
Local lDic    := .F. 		// Habilita/Desabilita Dicionario
Local lComp   := .T. 		// Habilita/Desabilita o Formato Comprimido/Expandido
Local lFiltro := .F. 		// Habilita/Desabilita o Filtro
Local wnrel   := "RPT0001"  // Nome do Arquivo utilizado no Spool
Local nomeprog:= "RPT0001" // Nome do programa
Local aPerg   := {}			// Array contendo as Variaveis do Dicionario de Perguntas

Private Tamanho := "G" 		// P/M/G
Private Limite  := 220 		// 80/132/220
Private aOrdem  := {}  		// Ordem do Relatorio
Private cPerg   := "RPT001"	// Pergunta do Relatorio
Private aReturn := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
						//[1] Reservado para Formulario
						//[2] Reservado para N� de Vias
						//[3] Destinatario
						//[4] Formato => 1-Comprimido 2-Normal
						//[5] Midia   => 1-Disco 2-Impressora
						//[6] Porta ou Arquivo 1-LPT1... 4-COM1...
						//[7] Expressao do Filtro
						//[8] Ordem a ser selecionada
						//[9]..[10]..[n] Campos a Processar (se houver)
Private lEnd    := .F.// Controle de cancelamento do relatorio
Private m_pag   := 1  // Contador de Paginas
Private nLastKey:= 0  // Controla o cancelamento da SetPrint e SetDefault

// Variaveis de Controle do Relat�rio
aAdd(aPerg,{cPerg,"Data Inicial     ?" ,"D",08,0,"G","","","","","","",""})
aAdd(aPerg,{cPerg,"Data Final       ?" ,"D",08,0,"G","","","","","","",""})
aAdd(aPerg,{cPerg,"Faturados        ?" ,"C",01,0,"G","","","","","","",""})
aAdd(aPerg,{cPerg,"Filial de        ?" ,"C",06,0,"G","","","","","","",""})
aAdd(aPerg,{cPerg,"Filial at�       ?" ,"C",06,0,"G","","","","","","",""})
aAdd(aPerg,{cPerg,"Boleto           ?" ,"C",01,0,"G","","","","","","",""})
aAdd(aPerg,{cPerg,"Dt Faturamento de?" ,"D",08,0,"G","","","","","","",""})
aAdd(aPerg,{cPerg,"Dt Faturamento at�?","D",08,0,"G","","","","","","",""})


U_TestaSX1(cPerg,aPerg)

// Verifica as Perguntas Seleciondas
Pergunte(cPerg,.F.)

//Envia para a SetPrinter                                                 
wnrel:=SetPrint(cString,wnrel,cPerg,@cTitulo,cDesc1,cDesc2,cDesc3,lDic,aOrdem,lComp,Tamanho,lFiltro)

If ( nLastKey==27 )
	Return(Nil)
Endif

SetDefault(aReturn,cString)

If ( nLastKey==27 )
	Return(Nil)
Endif

RptStatus({|lEnd| MontaTab()},"Montando Tabelas Tempor�rias")
RptStatus({|lEnd| ImprRel(@lEnd,wnRel,cString,nomeprog,cTitulo)},cTitulo)

// Fechar Tabelas Temporarias
	dbSelectArea("TMP1")
	dbCloseArea("TMP1")
Return(.T.)



Static Function MontaTab()
****************************************************************************************
* Monta Tabela Tempor�ria para Impress�o
*
*****

// Declara��o das Vari�veis
Local cQuery 	:= ""
Local cFat      := 1
Local cFilIni   := ""
Local cFilFin   := ""
Local dDeData   := CToD("")
Local dAteData  := CToD("")
Local cBol      := 1

// Recebe Parametros
dDtIni   := mv_par01                                      
dDtFin   := mv_par02 
cFat     := mv_par03
cFilIni  := mv_par04
cFilFin  := mv_par05
cBol     := mv_par06
dDtFatI  := mv_par07
dDtFatF  := mv_par08

cQuery := " SELECT C5_FILIAL, C5_ZPEDIDO, C5_NUM, C5_ZCONT, C5_CLIENTE, C5_LOJACLI, A1_NOME, A1_CGC, C5_VEND1, A3_NOME, C5_EMISSAO, SUM(C6_VALOR) AS C5_TOTAL, C5_PARC1, C5_DATA1, C5_PARC2, C5_DATA2, C5_PARC3, C5_DATA3, C5_PARC4, C5_DATA4, C5_PARC5, C5_DATA5, C5_PARC6, C5_DATA6, C5_NOTA, C5_SERIE, C5_OBRA, C5_ZENDOB, C5_ZMUNOB, C5_ZBAIROB, C5_ZESTOB, C5_ZBOLETO "
cQuery += " FROM "+RetSQLName("SC5")+ " JOIN "+RetSQLName("SC6")+" ON (C5_FILIAL  = C6_FILIAL AND C5_NUM=C6_NUM) "
cQuery += "             JOIN "+RetSQLName("SA1")+" ON (C5_CLIENTE = A1_COD AND C5_LOJACLI=A1_LOJA) "
cQuery += "             JOIN "+RetSQLName("SA3")+" ON (C5_VEND1   = A3_COD ) "
cQuery += " WHERE C5_ZTIPO  = '2' AND "
If     cFat = 1 
       cQuery += "       C5_NOTA   <> '' AND "
elseif cFat = 2
       cQuery += "       C5_NOTA   = ''  AND "
EndIF              
If     cBol = 1 
       cQuery += "       C5_ZBOLETO  = 'S' AND "
elseif cBol = 2
       cQuery += "       C5_ZBOLETO  = 'N' AND "
EndIF              

cQuery += "       C5_FILIAL  BETWEEN '"+cFilIni     +"' AND '"+cFilFin     +"' AND "
cQuery += "       C5_EMISSAO BETWEEN '"+DtoS(dDtIni)+"' AND '"+DtoS(dDtFin)+"' AND "

If cFat = 1 
   cQuery += " C5_FILIAL + C5_NOTA IN (SELECT F2_FILIAL + F2_DOC FROM "+RetSQLName("SF2")+" WHERE D_E_L_E_T_ <> '*' AND F2_EMISSAO BETWEEN '"+DtoS(dDtFatI)+"' AND '"+DtoS(dDtFatF)+"' ) AND "
Endif

cQuery += RetSQLName("SC5")+".D_E_L_E_T_ <> '*' AND "
cQuery += RetSQLName("SC6")+".D_E_L_E_T_ <> '*' AND "
cQuery += RetSQLName("SA3")+".D_E_L_E_T_ <> '*' AND "
cQuery += RetSQLName("SA1")+".D_E_L_E_T_ <> '*' "
cQuery += " GROUP BY C5_FILIAL, C5_ZPEDIDO, C5_NUM, C5_ZCONT, C5_CLIENTE, C5_LOJACLI, A1_NOME, A1_CGC, C5_VEND1, A3_NOME, C5_EMISSAO,  C5_PARC1, C5_DATA1, C5_PARC2, C5_DATA2, C5_PARC3, C5_DATA3, C5_PARC4, C5_DATA4, C5_PARC5, C5_DATA5, C5_PARC6, C5_DATA6, C5_NOTA, C5_SERIE, C5_OBRA,  C5_ZENDOB, C5_ZMUNOB, C5_ZBAIROB, C5_ZESTOB, C5_ZBOLETO "
cQuery += " order by C5_FILIAL, C5_NUM "     

TCQuery cQuery Alias "TMP1" New	
	

	
Return()



Static Function ImprRel(lEnd,wnrel,cString,nomeprog,cTitulo)
****************************************************************************************
* Imprime Relat�rio
*
*****

Local nLi     	:= 100 	// Contador de Linhas
Local lImp    	:= .F. 	// Indica se algo foi impresso
Local cbCont  	:= 0   	// Numero de Registros Processados
Local cbText  	:= "Dpto. Tecnologia da Informa��o - Topmix Engenharia e Tecnologia de Concretos SA."  // Mensagem do Rodape
Local cCabec1 	:= ""	// Cabe�alho 1
Local cCabec2 	:= ""	// Cabe�alho 2
Local nComp		:= If(aReturn[4]==1,15,18)	// Condensado ou Normal
Local cTipoNF	:= "" 	// Topo da NF


Local nTotalGeral    := 0 
Local nTotalFilial   := 0
Local cFilImp        := ""
Local nRegSM0        := 0

 
DbSelectArea("SM0")
nRegSM0 := SM0->(Recno())


cCabec1 := "Pedido KP         Pedido Emissao    Cliente                                  Contr CNPJ/CPF               TOTAL  NOTA-RPS /SER NFS-e     GISONLINE       END.OBRA                       BAIRRO          MUNICIPIO             "   

DbSelectArea("TMP1")
dbGoTop()

cFilImp := TMP1->C5_FILIAL
	
While !Eof()
		lImp := .T.
	
		If LastKey() = 286
			lEnd := .T.
		EndIf
		
		If lEnd
			@ Prow()+1,001 PSAY "CANCELADO PELO OPERADOR"
			Exit
		EndIf
		
		If ( nLi > 60 )
			nLi := Cabec(cTitulo,cCabec1,"","",Tamanho,nComp)
			nLi++
		Endif
/*
Pedido KP         Pedido Emissao    Cliente                                  Contr CNPJ/CPF               TOTAL  NOTA-RPS /SER NFS-e     GISONLINE       END.OBRA                       BAIRRO          MUNICIPIO             "   
100000000581      000000 99/99/9999 999999/99 012345678901234567890123456789 12345 71476527001530 999.999.999,99 000000000/999 999999999 999999999999999 123456789012345678901234567890 123456789012345 99999-123456789012345 "
0				      18	    25			36  	    46								 	  77    83             98             113       123 127       137             153                            184             200   206
01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
          1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
                                                                                 Total.......:   --------------"

*/ 
		//Imprime nome da filial...
		DBSelectArea("SM0")
		DBSetOrder(1)
		DBSeek(cEmpAnt+TMP1->C5_FILIAL)
			 
	   
   @ nLi, 00 PSay 'FILIAL -->> ' + TMP1->C5_FILIAL + " - " + left(SM0->M0_FILIAL,40) + " PER�ODO: " + DtoC(mv_par01) + " a " + DtoC(mv_par02)  + Iif(mv_par06<>3, " BOLETOS = "+SC5->C5_ZBOLETO , "")
   DBSelectArea("TMP1")
   nLi ++
   While (cFilImp = TMP1->C5_FILIAL)

		If ( nLi > 60 )
			nLi := Cabec(cTitulo,cCabec1,"","",Tamanho,nComp)
			nLi++
		Endif

		@ nLi, 000 PSay TMP1->C5_ZPEDIDO
		@ nLi, 018 PSay Trim(TMP1->C5_NUM)
		@ nLi, 025 PSay StoD(TMP1->C5_EMISSAO)

		@ nLi, 036 PSay TMP1->C5_CLIENTE + "/" + TMP1->C5_LOJACLI
		@ nLi, 046 PSay Left(TMP1->A1_NOME, 29) 
		@ nLi, 077 PSay TMP1->C5_ZCONT
		@ nLi, 083 PSay TMP1->A1_CGC
		
		@ nLi, 098 PSay TMP1->C5_TOTAL Picture "@R 999,999,999.99"
		@ nLi, 113 PSay TMP1->C5_NOTA 
		@ nLi, 122 PSay "/"+TMP1->C5_SERIE  
      if ! empty(trim(TMP1->C5_NOTA))   
         DbSelectArea("SF2")
         DBSetOrder(1)
         DBSeek(TMP1->C5_FILIAL + TMP1->C5_NOTA + TMP1->C5_SERIE)
         @ nLi, 127 PSay SF2->F2_NFELETR   
         DbSelectArea("TMP1")
      EndIF 
	   
	   @ nLi, 137 PSay TMP1->C5_OBRA
		@ nLi, 153 PSay LEFT(TMP1->C5_ZENDOB,30)
		@ nLi, 184 PSay LEFT(TMP1->C5_ZBAIROB,20)
		@ nLi, 200 PSay TMP1->C5_ZMUNOB
 		@ nLi, 205 PSay "-"+Posicione("CC2",1,xFilial("CC2") + TMP1->C5_ZESTOB + TMP1->C5_ZMUNOB,'CC2_MUN')
		
		// Soma Totais 
		nTotalGeral  += TMP1->C5_TOTAL
		nTotalFilial += TMP1->C5_TOTAL
		
      nLi++
        
	   dbSelectArea("TMP1")
		DbSkip()			
   End   
	// Total da Filial
	@ nli, 000 Psay "                                                                                                 --------------"
	nLi++
	@ nLi, 055 PSay "Subtotal filial: " + cFilImp
	@ nLi, 097 PSay nTotalFilial		Picture "@R 999,999,999.99"
   cFilImp := TMP1->C5_FILIAL
   nTotalFilial := 0
   nLi++
End
nLi++
nLi++
// Total Geral
@ nli, 000 Psay "                                                                                                 --------------"
nLi++
@ nLi, 077 PSay "Total Geral.: "
@ nLi, 097 PSay nTotalGeral		Picture "@R 999,999,999.99"
		
If (lImp)
	Roda(cbCont,cbText,Tamanho)
EndIf

If ( aReturn[5] = 1 )
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()       

DbSelectArea("SM0")
DbGoto(nRegSM0)


Return()
