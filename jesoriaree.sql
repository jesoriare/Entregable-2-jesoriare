SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE if EXISTS DEGREES;
DROP TABLE if EXISTS Subjects;
DROP TABLE if EXISTS Teachers;
DROP TABLE if EXISTS TeachersSubjects;
DROP TABLE if EXISTS Groups;
DROP TABLE if EXISTS Students;
DROP TABLE if EXISTS GroupsStudents;
DROP TABLE if EXISTS Grades;
DROP TABLE if EXISTS Departments;
DROP TABLE if EXISTS Offices;
DROP TABLE if EXISTS Classrooms;
DROP TABLE if EXISTS Mentory;
DROP TABLE if EXISTS MentoryAppoiments;


CREATE TABLE Degrees(
	degreeId INT NOT NULL AUTO_INCREMENT,
	NAME VARCHAR(60) NOT NULL UNIQUE,
	years INT DEFAULT(4) NOT NULL,
	PRIMARY KEY (degreeId),
	CONSTRAINT invalidDegreeYear CHECK (years >=3 AND years<=5)
);


CREATE TABLE Subjects(
	subjectId INT NOT NULL AUTO_INCREMENT,
	NAME VARCHAR(100) NOT NULL UNIQUE,
	acronym VARCHAR(8) NOT NULL UNIQUE,
	credits INT NOT NULL,
	YEAR INT NOT NULL,
	TYPE VARCHAR(20) NOT NULL,
	degreeId INT NOT NULL,
	PRIMARY KEY(subjectId),
	FOREIGN KEY (degreeId) REFERENCES degrees (degreeId),
	CONSTRAINT negativeSubjectCredits CHECK (credits > 0),
	CONSTRAINT invalidSubjectCouse CHECK (YEAR >= 1 AND YEAR <= 5),
	CONSTRAINT invalidSubjectType CHECK (TYPE IN (	'Formacion Basica',
																	'Optativa',
																	'Obligatoria'))
);


CREATE TABLE Groups(
	groupId INT NOT NULL AUTO_INCREMENT,
	NAME VARCHAR(30) NOT NULL,
	activity VARCHAR(20) NOT NULL,
	YEAR INT NOT NULL,
	subjectId INT NOT NULL,
	classroomId INT NOT NULL,
	PRIMARY KEY (groupId),
	FOREIGN KEY (subjectId) REFERENCES Subjects (subjectId),
	FOREIGN KEY (classroomId) REFERENCES Classrooms (classroomId),
	UNIQUE (NAME, YEAR, subjectId),
	CONSTRAINT negativeGroupYear CHECK (YEAR > 0),
	CONSTRAINT insvalidGroupActivity CHECK (activity IN ('Teoria',
																			'Laboratorio'))
);


CREATE TABLE Students(
	studentId INT NOT NULL AUTO_INCREMENT,
	dni CHAR(9) NOT NULL UNIQUE,
	firstName VARCHAR(100) NOT NULL,
	surnames VARCHAR(100) NOT NULL,
	bithDate DATE NOT NULL,
	email VARCHAR(100) NOT NULL,
	accesMethod VARCHAR(30) NOT NULL,
	PRIMARY KEY (studentId),
	CONSTRAINT invalidStudentAccessMethod CHECK(
			accesMethod IN(
					'Selectividad',
					'Ciclo Mayor',
					'Titulado Extranjero'))
);


CREATE TABLE GroupsStudents(
		groupStudentId INT NOT NULL AUTO_INCREMENT,
		groupId INT NOT NULL,
		studentId INT NOT NULL,
		PRIMARY KEY (groupStudentId),
		FOREIGN KEY (groupId) REFERENCES Groups (groupId),
		FOREIGN KEY (StudentId) REFERENCES Students (studentId),
		UNIQUE (groupId, studentId)
);


CREATE TABLE Grades(
		gradeId INT NOT NULL AUTO_INCREMENT,
		VALUE DECIMAL(4,2) NOT NULL,
		gradeConvo INT NOT NULL,
		matHonor BOOLEAN NOT NULL,
		studentId INT NOT NULL,
		groupId INT NOT NULL,
		PRIMARY KEY (gradeId),
		FOREIGN KEY (studentId) REFERENCES Students (studentId),
		FOREIGN KEY (groupId) REFERENCES Groups (groupId),
		CONSTRAINT invalidGradeValue CHECK (VALUE>=0 AND VALUE <=10),
		CONSTRAINT invalidGradeConvo CHECK (gradeConvo>=1 AND gradeConvo<=3),
		CONSTRAINT duplicatedConvoGrade UNIQUE (gradeConvo, studentId, groupId),
		CONSTRAINT cannotAssignHonor CHECK (NOT(matHonor AND VALUE<9))
);


CREATE TABLE Teachers(
		teacherId INT NOT NULL AUTO_INCREMENT,
		dni CHAR(9) NOT NULL UNIQUE,
		NAME VARCHAR(100) NOT NULL,
		surnames VARCHAR(100) NOT NULL,
		birthDate DATE NOT NULL,
		email VARCHAR(250) NOT NULL UNIQUE,
		category VARCHAR(39) NOT NULL,
		departmentId INT NOT NULL, 
		officeId INT NOT NULL,
		PRIMARY KEY (teacherId),
		FOREIGN KEY (departmentId) REFERENCES Departments (departmentId) ON DELETE CASCADE,
		FOREIGN KEY (officeId) REFERENCES Offices (officeId),
		CONSTRAINT invalidTeacherCategory CHECK( category IN(
				'Catedratico',
				'Titular de Universidad',
				'Profesor Contratado Doctor',
				'Profesor Ayudante Doctor'))
);


CREATE TABLE TeachersSubjects(
		teacherSubjectId INT NOT NULL AUTO_INCREMENT,
		teacherId INT NOT NULL,
		subjectId INT NOT NULL,
		PRIMARY KEY (teacherSubjectId),
		UNIQUE (teacherId, subjectId),
		FOREIGN KEY (teacherId) REFERENCES Teachers (teacherId),
		FOREIGN KEY (subjectId) REFERENCES Subjects (subjectId)
);


CREATE TABLE Departments(
		departmentId INT NOT NULL AUTO_INCREMENT,
		NAME VARCHAR(100) NOT NULL UNIQUE,
		PRIMARY  KEY (departmentId)
);


CREATE TABLE Offices(
		officeId INT NOT NULL AUTO_INCREMENT,
		NAME VARCHAR(100) NOT NULL UNIQUE,
		FLOOR INT NOT NULL,
		capacity INT NOT NULL,
		PRIMARY KEY (officeId),
		CONSTRAINT invalidFloorValue CHECK (FLOOR > 0),
		CONSTRAINT invalidCapacityValue CHECK (capacity > 0)
);


CREATE TABLE Mentories(
		mentoryId INT NOT NULL AUTO_INCREMENT,
		weekday VARCHAR(9) NOT NULL,
		starthour TIME NOT NULL,
		finishhour TIME NOT NULL,
		teacherId INT NOT NULL,
		PRIMARY KEY (mentoryId),
		UNIQUE (weekday, starthour, finishhour, teacherId),
		FOREIGN KEY (teacherId) REFERENCES Teachers (teacherId),
		CONSTRAINT invalidweekday CHECK (
				weekday IN (
							'Lunes',
							'Martes',
							'Miercoles',
							'Jueves',
							'Viernes',
							'Sabado',
							'Domingo'))
);


CREATE TABLE MentoryAppointments(
		MentoryAppointmentsId INT NOT NULL AUTO_INCREMENT,
		date DATE NOT NULL,
		hour TIME NOT NULL,
		mentoryId INT NOT NULL,
		studentId INT NOT NULL,
		PRIMARY KEY(MentoryAppointmentsId),
		UNIQUE (date, hour, studentId),
		FOREIGN KEY (mentoryId) REFERENCES Mentories (mentoryId) ON DELETE CASCADE,
		FOREIGN KEY (studentId) REFERENCES Students (studentId)
);
