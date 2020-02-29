#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"         
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc} TRACOM01
                             
Tela de consulta das notas x Cte

@type	function
@author Lapetina, Thadeu
@since  
@version P11,P12
@database MSSQL,Oracle


/*/
User Function TRACOM01()

	Private oDlg     	:= Nil
	versao por fora!kfhgfghfhgfjgfhgfghgf
	Private cTitulo  	:= "Consulta"  
	Private cNumNfori	:= SPACE(9)
	Private cNumNfCte	:= SPACE(9)
	Private cSerieOri	:= SPACE(3)
	Private cSerieCte	:= SPACE(3)
	Private cCtrlFrete 	:= SPACE(9)
	Private cFilialx    := SPACE(6)

	DEFINE FONT oFont NAME 'Arial' SIZE 0, -12 BOLD
	
	DEFINE MSDIALOG oDlg TITLE cTitulo FROM 000,000 TO 200,0700 PIXEL
		
		@ 06,06 TO 90,345 LABEL "Consultas" OF oDlg PIXEL
		
		@ 038,110 Say 	"Nf Origem:"    	   	SIZE 60,07 FONT oFont  		   				PIXEL OF oDlg
		@ 034,150 MSGET cNumNfori PICTURE "@!"  SIZE 050,10 								PIXEL OF oDlg
		
		@ 038,220 Say 	"Serie Origem:"	   		SIZE 60,07 FONT oFont  		   				PIXEL OF oDlg
		@ 034,280 MSGET cSerieOri           	SIZE 050,10  		   						PIXEL OF oDlg
		
		@ 018,220 Say 	"CTE:"      	   		SIZE 60,07 FONT oFont  		   				PIXEL OF oDlg
		@ 014,280 MSGET cNumNfCte  PICTURE "@!" SIZE 050,10 								PIXEL OF oDlg 
		
		@ 038,014 Say 	"Serie CTE:"    		SIZE 60,07 FONT oFont  		   				PIXEL OF oDlg
		@ 034,050 MSGET cSerieCte           	SIZE 050,10  		   						PIXEL OF oDlg 
		
		@ 018,110 Say 	"Lote:"     			SIZE 60,07 FONT oFont  		   				PIXEL OF oDlg
		@ 014,150 MSGET cCtrlFrete    			SIZE 050,10  								PIXEL OF oDlg

		@ 018,014 Say 	"Filial:"           	SIZE 60,07 FONT oFont  		   				PIXEL OF oDlg
		@ 014,050 MSGET cFilialx     			SIZE 050,10  								PIXEL OF oDlg		
						
		@ 064,225 BUTTON "Consultar"   SIZE 40,15   ACTION (u_FConsulta(cNumNfori,;
																		cSerieOri,;
																		cNumNfCte,;
																		cSerieCte,;
																		cCtrlFrete )) 
		@ 064,285 BUTTON "Cancelar"    SIZE 40,15   ACTION (oDlg:End()) 
	
	ACTIVATE MSDIALOG oDlg CENTER
Return

User Function FConsulta(cNumNfori,cSerieOri,cNumNfCte,cSerieCte, cCtrlFrete)

	Local lWhere:= 		.F.
	
	Private oDlg2     	:= Nil
	Private cName   	:= "Consulta"  
	Private oLbx     	:= Nil
	Private aVetor   	:= {}	

	aVetor   := {}
	
	If !Empty(cNumNfori) .OR. !Empty(cSerieOri) .OR. !Empty(cNumNfCte) .OR. !Empty(cSerieCte) .OR. !Empty(cCtrlFrete)			
		lWhere:= .T.
	Endif	
	
	cQry = "  SELECT  			 		" + CRLF
	cQry +="  	ZN9.ZN9_FILIAL,  		" + CRLF 
	cQry +="  	ZM9.ZM9_NUMFRE,  		" + CRLF 
	cQry +="  	ZN9.ZN9_CTEDOC,  		" + CRLF 
	cQry +="  	ZN9.ZN9_CTESER,  		" + CRLF 
	cQry +="  	ZM9.ZM9_CHCTE,   		" + CRLF
	cQry +="  	ZM9.ZM9_VALOR,   		" + CRLF 
	cQry +="  	ZN9.ZN9_NUMNFO,  		" + CRLF  
	cQry +="    ZN9.ZN9_SERORI, 		" + CRLF
	cQry +=" 	ZN9.ZN9_VALNF   		" + CRLF
	cQry +="  FROM 				 		" + CRLF   
	cQry +=" 	"+RetSqlTab("ZN9")+"  		 		" + CRLF   
	cQry +=" 	INNER JOIN "+RetSqlTab("ZM9")+" ON  	" + CRLF   
	cQry +="  	ZM9.ZM9_FILIAL = ZN9.ZN9_FILIAL  " + CRLF
	cQry +="	AND " + CRLF
	cQry +="	ZN9.ZN9_CTEDOC = ZM9.ZM9_CTEDOC " + CRLF 
	cQry +="	AND " + CRLF 
	cQry +="	ZM9.ZM9_CTESER = ZN9.ZN9_CTESER" + CRLF 
	cQry +="	AND "  + CRLF
	cQry +=		RetSqlDel("ZM9") + CRLF 	
	cQry +="	AND "  + CRLF
	cQry +=     RetSqlDel("ZN9") + CRLF

	If lWhere
		cQry += " 	WHERE "+ CRLF	
		If !Empty(alltrim(cNumNfori)) 
			cQry += "  ZN9.ZN9_NUMNFO LIKE '%"+alltrim(cNumNfori)+"%' " + CRLF
		Endif	
		If !Empty(alltrim(cSerieOri))
			If !Empty(alltrim(cNumNfori))		
				cQry += "	AND "  + CRLF		
				cQry += " ZN9.ZN9_SERORI = '"+alltrim(cSerieOri)+"'      " + CRLF
			Else			 
				cQry += " ZN9.ZN9_SERORI = '"+alltrim(cSerieOri)+"'      " + CRLF
			Endif
		Endif	
		
		If !Empty(alltrim(cNumNfCte))
			If !Empty(alltrim(cNumNfori)) .OR. !Empty(alltrim(cSerieOri))	
				cQry += "	AND "  + CRLF		
				cQry += " ZN9.ZN9_CTEDOC LIKE '%"+alltrim(cNumNfCte)+"%'      " + CRLF
			Else			 
				cQry += " ZN9.ZN9_CTEDOC LIKE '%"+alltrim(cNumNfCte)+"%'      " + CRLF
			Endif
		Endif	

		If !Empty(alltrim(cSerieCte))
			If !Empty(alltrim(cNumNfori)) .OR. !Empty(alltrim(cSerieOri)) .OR. !Empty(alltrim(cNumNfCte))
				cQry += "	AND "  + CRLF		
				cQry += " ZN9.ZN9_CTESER = '"+alltrim(cSerieCte)+"'      " + CRLF
			Else			 
				cQry += " ZN9.ZN9_CTESER = '"+alltrim(cSerieCte)+"'      " + CRLF
			Endif
		Endif	
		
		If !Empty(alltrim(cCtrlFrete))
			If !Empty(alltrim(cNumNfori)) .OR. !Empty(alltrim(cSerieOri)) .OR. !Empty(alltrim(cNumNfCte)) .OR. !Empty(alltrim(cSerieCte))
				cQry += "	AND "  + CRLF		
				cQry += " ZM9.ZM9_NUMFRE LIKE '%"+alltrim(cCtrlFrete)+"%'      " + CRLF
			Else			 
				cQry += " ZM9.ZM9_NUMFRE LIKE '%"+alltrim(cCtrlFrete)+"%'      " + CRLF
			Endif
			
		Endif	
		If !Empty(alltrim(cFilialx)) 
			If !Empty(alltrim(cNumNfori)) .OR. !Empty(alltrim(cSerieOri)) .OR. !Empty(alltrim(cNumNfCte)) .OR. !Empty(alltrim(cSerieCte))		
				cQry += "	AND "  + CRLF	
				cQry += "  ZN9.ZN9_FILIAL LIKE '%"+alltrim(cFilialx)+"%' " + CRLF
			Else
				cQry += "  ZN9.ZN9_FILIAL LIKE '%"+alltrim(cFilialx)+"%' " + CRLF
			Endif
		Endif										
	Endif


	MemoWrite("\sql\TRACOM01.sql",cQry)
	TcQuery cQry New Alias "TRB" // Cria tabela temporária

	If TRB->(!Eof()) //Se houver dados
		
		//Percorre os Dados da Consulta
		While TRB->(!Eof())
			
			aAdd( aVetor, { TRB->ZN9_FILIAL, TRB->ZM9_NUMFRE, TRB->ZN9_CTEDOC,TRB->ZN9_CTESER, TRB->ZM9_CHCTE, TRB->ZM9_VALOR,;
				TRB->ZN9_NUMNFO, TRB->ZN9_SERORI, TRB->ZN9_VALNF } )
			TRB->( dbSkip () )
		EndDo
		TRB->(DbCloseArea())
	
		DEFINE MSDIALOG oDlg2 TITLE cName FROM 0,0 TO 550,880 PIXEL
	
		@ 10,10 LISTBOX oLbx FIELDS HEADER ;
											"Filial",;
											"Lote",;
											"CTE",;
											"CTE Serie",;
											"Chave",;
											"Valor CTE",;
											"NF Origem",;
											"Série Origem",;																														
											"Valor",;
		SIZE 420,230 OF oDlg2 PIXEL
		oLbx:Reset()
		oLbx:SetArray( aVetor )
		oLbx:bLine := {|| {aVetor[oLbx:nAt,1],;
		                   aVetor[oLbx:nAt,2],;
		                   aVetor[oLbx:nAt,3],;
		                   aVetor[oLbx:nAt,4],;
		                   aVetor[oLbx:nAt,5],;
		                   aVetor[oLbx:nAt,6],;
		                   aVetor[oLbx:nAt,7],;
		                   aVetor[oLbx:nAt,8],;
		                   aVetor[oLbx:nAt,9]}}
	
		DEFINE SBUTTON FROM 252,405 TYPE 2 ACTION (oDlg2:End() )    			ENABLE OF oDlg2
		 
		ACTIVATE MSDIALOG oDlg2 CENTER	
	Else
		MsgBox("Não há dados.","Atenção","ALERT")
		
		If Select("TRB") > 0
			TRB->(DbCloseArea()) // Fecha a area
		Endif
	 	
	EndIf		
Return
