
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

alter PROCEDURE [dbo].DataBaseToWord

AS
BEGIN
	SELECT obj.name 表名,ep.value 表描述   
	FROM sysobjects obj 
	LEFT JOIN  sys.extended_properties ep  ON ep.major_id=obj.id  and ep.minor_id=0
	WHERE xtype = 'U'    
 

    SELECT  col.colorder AS 序号 ,  
			col.name AS 字段名 ,  
			t.name + '(' + CAST( col.length as varchar) + ')' AS 数据类型 ,   
			CASE WHEN EXISTS ( SELECT   1  
							   FROM     dbo.sysindexes si  
										INNER JOIN dbo.sysindexkeys sik ON si.id = sik.id  
																  AND si.indid = sik.indid  
										INNER JOIN dbo.syscolumns sc ON sc.id = sik.id  
																  AND sc.colid = sik.colid  
										INNER JOIN dbo.sysobjects so ON so.name = si.name  
																  AND so.xtype = 'PK'  
							   WHERE    sc.id = col.id  
										AND sc.colid = col.colid ) THEN '是'  
				 ELSE ''  
			END AS 主键 ,  
			CASE WHEN col.isnullable = 1 THEN '是'  
				 ELSE ''  
			END AS 可空 ,
			ISNULL(ep.[value], '') AS 列说明 ,
			obj.name  AS 表名
	FROM    dbo.syscolumns col  
			LEFT  JOIN dbo.systypes t ON col.xtype = t.xusertype  
			inner JOIN dbo.sysobjects obj ON col.id = obj.id  
											 AND obj.xtype = 'U'  
											 AND obj.status >= 0   
			LEFT  JOIN sys.extended_properties ep ON col.id = ep.major_id  
														  AND col.colid = ep.minor_id  
														  AND ep.name = 'MS_Description'  
	ORDER BY obj.name,col.colorder ;  


	SELECT case xtype when 'U' then '表' when 'P' then '存储过程' when 'V' then '视图' when 'TR' then '触发器' end as 类型, 
	cast(count(*) as varchar) as 数量
	FROM   sysobjects 
	WHERE xtype in ( 'U','P','V','TR' ) 
	group by xtype;

	;with t1
	as
	(
    SELECT obj.name 表名,ep.value 表描述   ,count(*) as 字段数
	FROM sysobjects obj inner join  dbo.syscolumns col  ON col.id = obj.id  											 
	LEFT JOIN  sys.extended_properties ep  ON ep.major_id=obj.id  and ep.minor_id=0
	WHERE obj.xtype = 'U'   AND obj.status >= 0  
	group by obj.name,ep.value
	)
	select * from t1
	union
	select  '','',sum(字段数) from t1

	select (SELECT DB_NAME(dbid) FROM master.dbo.sysprocesses sp WHERE sp.status='runnable') as 数据库名,
	(SELECT  count(*) FROM     sysobjects col WHERE xtype = 'U'  ) as 表总数   ,
    @@SERVERNAME as '服务器名',
    @@VERSION as '数据库版本',
	getdate() as '生成时间'
end