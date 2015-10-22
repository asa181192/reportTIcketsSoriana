
DECLARE @id int ,@titulo varchar(150),@descripcion varchar(MAX),@fechacreated datetime,@fechafinal datetime

DECLARE CCURSOR CURSOR FOR 

select workorder.WORKORDERID AS TICKET,
workorder.TITLE ,
workorder.DESCRIPTION AS DESCRIPCION,
dateadd(s,datediff(s,GETUTCDATE() ,getdate()) + (CREATEDTIME/1000),'1970-01-01 00:00:00') 'FECHA INICIO',
dateadd(s,datediff(s,GETUTCDATE() ,getdate()) + (RESOLVEDTIME/1000),'1970-01-01 00:00:00') 'FECHA FINAL'

 from  workorder (NOLOCK) 
 INNER JOIN WorkOrderStates ON workorder.WORKORDERID = WorkOrderStates.WORKORDERID
 WHERE 
(
dateadd(s,datediff(s,GETUTCDATE() ,getdate()) + (workorder.CREATEDTIME/1000),'1970-01-01 00:00:00') >= convert(varchar,'2015-01-01 00:00',21)  
AND
dateadd(s,datediff(s,GETUTCDATE() ,getdate()) + (workorder.CREATEDTIME/1000),'1970-01-01 00:00:00') <= convert(varchar,'2015-10-01 23:59',21)  
)
AND
(
WORKORDER.DESCRIPTION LIKE '%soriana%' OR WORKORDER.TITLE LIKE '%soriana%' 
)

OPEN CCURSOR 

FETCH CCURSOR INTO @id,@titulo,@descripcion,@fechacreated,@fechafinal
WHILE (@@FETCH_STATUS=0)
	BEGIN
		
		select @id AS TICKET ,
		@titulo AS TITULO,
		@descripcion AS DESCRIPCION,
		@fechacreated AS INICIO,
		@fechafinal AS FINAL ,
		convert  (varchar(5),DateDiff(s, @fechacreated, @fechafinal)/86400)+':'+convert(varchar(5),(DateDiff(s, @fechacreated, @fechafinal)%86400)/3600)+':'+convert(varchar(5),((DateDiff(s, @fechacreated, @fechafinal)%86400)%3600)/60)+':'+convert(varchar(5),(((DateDiff(s, @fechacreated, @fechafinal)%86400)%3600)%60)) as 'DD:HH:MM:SS'
		FETCH CCURSOR INTO @id,@titulo,@descripcion,@fechacreated,@fechafinal
		
	END
CLOSE CCURSOR
DEALLOCATE CCURSOR

