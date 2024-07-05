--Tabel awal:
CREATE TABLE teachers ( id INT AUTO_INCREMENT, name VARCHAR(100), subject VARCHAR(50), PRIMARY KEY(id) ); 
INSERT INTO teachers (name, subject) VALUES ('Pak Anton', 'Matematika'); 
INSERT INTO teachers (name, subject) VALUES ('Bu Dina', 'Bahasa Indonesia'); 
INSERT INTO teachers (name, subject) VALUES ('Pak Eko', 'Biologi'); 
CREATE TABLE classes ( id INT AUTO_INCREMENT, name VARCHAR(50), teacher_id INT, PRIMARY KEY(id), FOREIGN KEY (teacher_id) REFERENCES teachers(id) ); 
INSERT INTO classes (name, teacher_id) VALUES ('Kelas 10A', 1); 
INSERT INTO classes (name, teacher_id) VALUES ('Kelas 11B', 2); 
INSERT INTO classes (name, teacher_id) VALUES ('Kelas 12C', 3); 
CREATE TABLE students ( id INT AUTO_INCREMENT, name VARCHAR(100), age INT, class_id INT, PRIMARY KEY(id), FOREIGN KEY (class_id) REFERENCES classes(id) ); 
INSERT INTO students (name, age, class_id) VALUES ('Budi', 16, 1); 
INSERT INTO students (name, age, class_id) VALUES ('Ani', 17, 2); 
INSERT INTO students (name, age, class_id) VALUES ('Candra', 18, 3);

--Tabel Modifikasi:
CREATE TABLE teachers ( 
	id SERIAL primary KEY, 
	name VARCHAR(100), 
	subject VARCHAR(50),
	unique (name, subject));
INSERT INTO teachers (name, subject) VALUES ('Pak Anton', 'Matematika'); 
INSERT INTO teachers (name, subject) VALUES ('Bu Dina', 'Bahasa Indonesia'); 
INSERT INTO teachers (name, subject) VALUES ('Pak Eko', 'Biologi'); 
CREATE TABLE classes ( 
	id SERIAL primary KEY, 
	name VARCHAR(50), 
	teacher_id INT,
	unique (name, teacher_id),
	FOREIGN KEY (teacher_id) 
	REFERENCES teachers(id) ); 
INSERT INTO classes (name, teacher_id) VALUES ('Kelas 10A', 1); 
INSERT INTO classes (name, teacher_id) VALUES ('Kelas 11B', 2); 
INSERT INTO classes (name, teacher_id) VALUES ('Kelas 12C', 3); 
CREATE TABLE students ( 
	id serial primary key,
	name VARCHAR(100), 
	age INT, 
	class_id INT,
	unique (name, age, class_id),
	FOREIGN KEY (class_id) 
	REFERENCES classes(id) ); 
INSERT INTO students (name, age, class_id) VALUES ('Budi', 16, 1); 
INSERT INTO students (name, age, class_id) VALUES ('Ani', 17, 2); 
INSERT INTO students (name, age, class_id) VALUES ('Candra', 18, 3);

--Saya memodifikasi tabel supaya tidak ada duplikat data serta kompatibel dengan postgreSQL

--1. Tampilkan daftar siswa beserta kelas dan guru yang mengajar kelas tersebut.
select 
students.name, classes.name, teachers.name  
from classes 
inner join students ON classes.id = students.class_id 
inner join teachers on classes.teacher_id = teachers.id ;

--2. Tampilkan daftar kelas yang diajar oleh guru yang sama.
select * from classes inner join teachers on classes.teacher_id = teachers.id where teachers.name = 'Pak Anton';

--3. buat query view untuk siswa, kelas, dan guru yang mengajar
create or replace view class_view 
as
select students.name, classes.name as classes, teachers.name as teacher 
from 
classes 
inner join students ON classes.id = students.class_id 
inner join teachers on classes.teacher_id = teachers.id ;
select * from class_view;

--4. buat query yang sama tapi menggunakan store_procedure
create or replace procedure class_procedure()
language plpgsql 
as $$
begin
	select students.name, classes.name as classes, teachers.name as teacher 
	from 
		classes 
	inner join students ON classes.id = students.class_id 
	inner join teachers on classes.teacher_id = teachers.id;
	return;
end;
$$;
call class_procedure();

--query tidak bisa dijalankan di procedure karena procedure hanya bisa menerima query yang mmemiliki tujuan untuk hasil datanya dan tidak bisa mengeluarkan nilai return. Function lebih cocok digunakan untuk kasus ini.
