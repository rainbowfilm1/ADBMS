Implementation of Analytical queries like Roll_UP, CUBE,
First, Last, Rank and Dense Rank.

// Create a Table 

CREATE TABLE emp (
  empno INT(4) PRIMARY KEY,
  ename VARCHAR(10),
  job VARCHAR(9),
  mgr INT(4),
  hiredate DATE,
  sal DECIMAL(7,2),
  comm DECIMAL(7,2),
  deptno INT(2));
  
  // Use to Show the Tables
  show tables;
  
  // Show Colums of the Table 
  
  show columns from emp;
  
// Insert Data in the emp Table

insert into emp values (7369,'SMITH','CLERK',7902,'1980-12-17',800,null,20);
insert into emp values (7499,'ALLEN','SALESMAN',7698,'1980-12-17',1600,300,30);
insert into emp values (7521,'WARD','SALESMAN',7698,'1980-12-17',1250,500,30);
insert into emp values (7566,'JONES','MANAGER',7839,'1980-12-17',2975,null,20);
insert into emp values (7654,'MARTIN','SALESMAN',7698,'1980-12-17',1250,1400,30);
insert into emp values (7698,'BLAKE','MANAGER',7839,'1980-12-17',2850,null,30);
insert into emp values (7782,'CLARK','MANAGER',7839,'1980-12-17',2450,null,10);
insert into emp values (7788,'SCOTT','ANALYST',7566,'1980-12-17',3000,null,20);
insert into emp values (7839,'KING','PRESIDENT',null,'1980-12-17',5000,null,10);
insert into emp values (7844,'TURNER','SALESMAN',7698,'1980-12-17',1500,0,30);
insert into emp values (7876,'ADAMS','CLERK',7788,'1980-12-17',1100,null,20);
insert into emp values (7900,'JAMES','CLERK',7698,'1980-12-17',950,null,30);
insert into emp values (7902,'FORD','ANALYST',7566,'1980-12-17',3000,null,20);
insert into emp values (7934,'MILLER','CLERK',7782,'1980-12-17',1300,null,10);

// Show the table data 

select * from emp;

// ROLLUP 

SELECT empno, sal, SUM(sal) AS Totalsal
FROM emp
GROUP BY empno, sal WITH ROLLUP;



// CUBE

 SELECT empno, sal, SUM(sal) AS Totalsal 
 FROM emp
 GROUP BY CUBE(sal);     ( Note Cube is not supporting in MY SQL but support in SQL )

 // RANK 
 
 SELECT empno, deptno, sal, RANK() OVER (PARTITION BY deptno ORDER BY sal) AS myrank FROM emp;
 
 SELECT *
FROM (
  SELECT empno, deptno, sal, 
         RANK() OVER (PARTITION BY deptno ORDER BY sal) AS myrank 
  FROM emp
)t 
WHERE myrank <= 2;

// DENSE_RANK:

 SELECT empno, deptno, sal, DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal) AS myrank FROM emp;
 
 // FIRST & LAST 
 
  
SELECT empno, deptno, sal,
       MIN(sal) OVER (PARTITION BY deptno ORDER BY sal ASC
                      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS lowest,
       MAX(sal) OVER (PARTITION BY deptno ORDER BY sal ASC
                      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS highest
FROM emp
ORDER BY deptno, sal;

//  MIN & MAX
SELECT 
    empno,
    deptno,
    sal,
    (SELECT MIN(sal) 
     FROM emp e2 
     WHERE e1.deptno = e2.deptno 
     ORDER BY sal 
     LIMIT 1) AS lowest,
    (SELECT MAX(sal) 
     FROM emp e2 
     WHERE e1.deptno = e2.deptno 
     ORDER BY sal DESC 
     LIMIT 1) AS highest
FROM emp e1
ORDER BY deptno, sal;

// LAG 

SELECT empno, ename, job, sal, LAG(sal, 1, 0) OVER (ORDER BY sal) AS sal_prev, sal - LAG(sal, 1, 0) OVER (ORDER BY sal) AS sal_diff
FROM emp;”

// Colum has defult value ZERO

SELECT deptno, empno, ename, job, sal,
LAG(sal, 1, 0) OVER (PARTITION BY deptno ORDER BY sal) AS sal_prev FROM emp;”




// LEAD 

SELECT empno, ename, job, sal,
LEAD(sal, 1, 0) OVER (ORDER BY sal) AS sal_next, LEAD(sal, 1, 0) OVER (ORDER BY sal) - sal AS sal_diff FROM emp;”


SELECT deptno, empno, ename, job, sal,
LEAD(sal, 1, 0) OVER (PARTITION BY deptno ORDER BY sal) AS sal_next FROM emp;”
 