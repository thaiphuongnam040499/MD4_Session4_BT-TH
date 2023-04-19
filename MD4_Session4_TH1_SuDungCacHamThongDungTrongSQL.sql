CREATE DATABASE QuanLySinhVienS4;
USE QuanLySinhVienS4;
CREATE TABLE Class(
    ClassID   INT         NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ClassName VARCHAR(60) NOT NULL,
    StartDate DATETIME,
    Status    BIT
);
CREATE TABLE Student(
    StudentId   INT         NOT NULL AUTO_INCREMENT PRIMARY KEY,
    StudentName VARCHAR(30) NOT NULL,
    Address     VARCHAR(50),
    Phone       VARCHAR(20),
    Status      BIT,
    ClassId     INT         NOT NULL,
    FOREIGN KEY (ClassId) REFERENCES Class (ClassID)
);
CREATE TABLE Subject(
    SubId   INT         NOT NULL AUTO_INCREMENT PRIMARY KEY,
    SubName VARCHAR(30) NOT NULL,
    Credit  TINYINT     NOT NULL DEFAULT 1 CHECK ( Credit >= 1 ),
    Status  BIT                  DEFAULT 1
);
CREATE TABLE Mark(
    MarkId    INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    SubId     INT NOT NULL,
    StudentId INT NOT NULL,
    Mark      FLOAT   DEFAULT 0 CHECK ( Mark BETWEEN 0 AND 100),
    ExamTimes TINYINT DEFAULT 1,
    UNIQUE (SubId, StudentId),
    FOREIGN KEY (SubId) REFERENCES Subject (SubId),
    FOREIGN KEY (StudentId) REFERENCES Student (StudentId)
);
insert into Class(ClassName,StartDate,Status) values
("A1","2008-12-20",1),
("A2","2008-12-22",1),
("B3",current_date(),0);

insert into Student(StudentName,Address,Phone,Status,ClassId) values
("Hung", "HN", "0912113113", 1,1),
("Hoa", "HP", null, 1,1),
("Manh", "HCM", "0123123123", 0,2);

insert into Subject(SubName,Credit,Status) values
("CF",5,1),
("C",6,1),
("HDJ",5,1),
("RDBMS",10,1);

insert into Mark(SubId,StudentId,Mark,ExamTimes) values
(1, 1, 8, 1),
(1, 2, 10, 2),
(2, 1, 12, 1);
-- THUCHANH
 -- Sử dụng hàm count để hiển thị số lượng sinh viên ở từng nơi 
SELECT Address, COUNT(StudentId) AS 'Số lượng học viên'
FROM Student
GROUP BY Address;
-- Tính điểm trung bình các môn học của mỗi học viên bằng cách sử dụng hàm AVG
SELECT S.StudentId,S.StudentName, AVG(Mark)
FROM Student S join Mark M on S.StudentId = M.StudentId
GROUP BY S.StudentId, S.StudentName;
-- Hiển thị những bạn học viên co điểm trung bình các môn học lớn hơn 15
SELECT S.StudentId,S.StudentName, AVG(Mark)
FROM Student S join Mark M on S.StudentId = M.StudentId
GROUP BY S.StudentId, S.StudentName;
SELECT S.StudentId,S.StudentName, AVG(Mark)
FROM Student S join Mark M on S.StudentId = M.StudentId
GROUP BY S.StudentId, S.StudentName
HAVING AVG(Mark) > 15;
-- Hiển thị thông tin các học viên có điểm trung bình lớn nhất.
SELECT S.StudentId, S.StudentName, AVG(Mark)
FROM Student S join Mark M on S.StudentId = M.StudentId
GROUP BY S.StudentId, S.StudentName;
SELECT S.StudentId, S.StudentName, AVG(Mark)
FROM Student S join Mark M on S.StudentId = M.StudentId
GROUP BY S.StudentId, S.StudentName
HAVING AVG(Mark) >= ALL (SELECT AVG(Mark) FROM Mark GROUP BY Mark.StudentId);
-- END THUCHANH

-- BAITAP
-- •	Hiển thị tất cả các thông tin môn học (bảng subject) có credit lớn nhất.
select * from Subject where (credit = (select max(Credit) as max_credit from Subject));
-- •	Hiển thị các thông tin môn học có điểm thi lớn nhất.
select s.SubId,S.SubName, m.Mark from Subject s join Mark m on s.SubId = m.SubId 
where (Mark = (select max(Mark) as max_mark from Mark));
-- •	Hiển thị các thông tin sinh viên và điểm trung bình của mỗi sinh viên, xếp hạng theo thứ tự điểm giảm dần
select s.StudentId, s.StudentName, avg(Mark) from Student s join Mark m on s.StudentId = m.StudentId GROUP BY s.StudentId, s.StudentName;