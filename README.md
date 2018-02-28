# WordReport
   一个通用的Word报告生成程序, 将Dataset中的数据按照设定的规则写入模板,支持导出docx、doc和PDF.
   
   功能已经实现, 一些细节暂未处理, 比如对于模板配置错误时的友好提示和日志.
   速度有点慢, 据说OpenXML会好很多,但据说只支持word的docx版本,导出doc和pdf不知道是否可行, 有时间深入研究一下.
   
   
# Demo
做了个将Sql Server数据库的表结构导出的demo.

# 使用方法
1.将文档需要的数据整理到一个Dataset(本文以sql server做的例子, 您可以使用其他的).
2.新建一个docx格式的word文档, 通过新建书签的方式划定区域,规则见下文.
3.根据书签中的描述, 系统自动将数据写入相应位置.

# 模板规则
  见我的博客http://www.cnblogs.com/FlyLolo/p/7884035.html. 当时写的有点粗糙, 有时间整理一下
