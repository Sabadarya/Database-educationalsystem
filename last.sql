-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`person`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`person` (
  `idperson` INT NOT NULL,
  `person_fname` VARCHAR(20) NULL,
  `address` VARCHAR(100) NULL,
  `phone1` VARCHAR(45) NULL,
  `phone2` VARCHAR(45) NULL,
  `date of birth` DATE NULL,
  `father_name` VARCHAR(20) NULL,
  `person_lname` VARCHAR(45) NULL,
  `email` VARCHAR(60) NULL,
  `gender` ENUM('f','m') NULL,
  PRIMARY KEY (`idperson`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`university`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`university` (
  `university_id` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `establishment_date` DATE NULL,
  `HOU` INT NOT NULL,
  `address` VARCHAR(100) NULL,
  `phone` VARCHAR(45) NULL,
  PRIMARY KEY (`university_id`),
  INDEX `fk_university_professor1_idx` (`HOU` ASC) VISIBLE,
  CONSTRAINT `fk_university_professor1`
    FOREIGN KEY (`HOU`)
    REFERENCES `mydb`.`professor` (`idprofessor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`college`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`college` (
  `college_id` INT NOT NULL,
  `college_name` VARCHAR(45) NULL,
  `location` VARCHAR(70) NULL,
  `phone number` VARCHAR(45) NULL,
  `website` VARCHAR(45) NULL,
  `university_id` INT NOT NULL,
  `deanofcollege` INT NOT NULL,
  PRIMARY KEY (`college_id`),
  INDEX `fk_college_university1_idx` (`university_id` ASC) VISIBLE,
  INDEX `fk_college_professor1_idx` (`deanofcollege` ASC) VISIBLE,
  CONSTRAINT `fk_college_university1`
    FOREIGN KEY (`university_id`)
    REFERENCES `mydb`.`university` (`university_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_college_professor1`
    FOREIGN KEY (`deanofcollege`)
    REFERENCES `mydb`.`professor` (`idprofessor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`depatment`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`depatment` (
  `depatment_id` INT NOT NULL,
  `department_name` VARCHAR(45) NULL,
  `headofdepartment` INT NOT NULL,
  `college_id` INT NOT NULL,
  PRIMARY KEY (`depatment_id`),
  INDEX `fk_depatment_professor1_idx` (`headofdepartment` ASC) VISIBLE,
  INDEX `fk_depatment_college1_idx` (`college_id` ASC) VISIBLE,
  CONSTRAINT `fk_depatment_professor1`
    FOREIGN KEY (`headofdepartment`)
    REFERENCES `mydb`.`professor` (`idprofessor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_depatment_college1`
    FOREIGN KEY (`college_id`)
    REFERENCES `mydb`.`college` (`college_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`professor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`professor` (
  `idprofessor` INT NOT NULL,
  `prof_title` ENUM('ASSISTANT PROF','ASSOCIATE PROF','TEACHER','PROFESSOR') NULL,
  `hiredate` YEAR NULL,
  `national_id` INT NOT NULL,
  `depatment_id` INT NOT NULL,
  PRIMARY KEY (`idprofessor`),
  INDEX `fk_professor_person1_idx` (`national_id` ASC) VISIBLE,
  INDEX `fk_professor_depatment1_idx` (`depatment_id` ASC) VISIBLE,
  CONSTRAINT `fk_professor_person1`
    FOREIGN KEY (`national_id`)
    REFERENCES `mydb`.`person` (`idperson`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_professor_depatment1`
    FOREIGN KEY (`depatment_id`)
    REFERENCES `mydb`.`depatment` (`depatment_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`majors`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`majors` (
  `major_id` INT NOT NULL,
  `major_name` VARCHAR(45) NOT NULL,
  `depatment_id` INT NOT NULL,
  PRIMARY KEY (`major_id`),
  INDEX `fk_majors_depatment1_idx` (`depatment_id` ASC) VISIBLE,
  CONSTRAINT `fk_majors_depatment1`
    FOREIGN KEY (`depatment_id`)
    REFERENCES `mydb`.`depatment` (`depatment_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`student`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`student` (
  `st_id` INT NOT NULL,
  `national_id` INT NOT NULL,
  `professor_advisor` INT NOT NULL,
  `registered_major_id` INT NOT NULL,
  PRIMARY KEY (`st_id`),
  INDEX `fk_student_person1_idx` (`national_id` ASC) VISIBLE,
  INDEX `fk_student_professor1_idx` (`professor_advisor` ASC) VISIBLE,
  INDEX `fk_student_majors1_idx` (`registered_major_id` ASC) VISIBLE,
  CONSTRAINT `fk_student_person1`
    FOREIGN KEY (`national_id`)
    REFERENCES `mydb`.`person` (`idperson`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_student_professor1`
    FOREIGN KEY (`professor_advisor`)
    REFERENCES `mydb`.`professor` (`idprofessor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_student_majors1`
    FOREIGN KEY (`registered_major_id`)
    REFERENCES `mydb`.`majors` (`major_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`course`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`course` (
  `co_id` INT NOT NULL,
  `course_name` VARCHAR(45) NULL,
  `credit` INT NULL,
  `courselevel` ENUM('ba','ma','phd') NULL,
  `coursetype` ENUM('proj', 'theo', 'lab') NULL,
  `status` ENUM('op','man') NULL,
  `department_id` INT NOT NULL,
  PRIMARY KEY (`co_id`),
  INDEX `fk_course_depatment1_idx` (`department_id` ASC) VISIBLE,
  CONSTRAINT `fk_course_depatment1`
    FOREIGN KEY (`department_id`)
    REFERENCES `mydb`.`depatment` (`depatment_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`classroom`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`classroom` (
  `classroom_id` INT NOT NULL,
  `floor` INT NULL,
  `college_id` INT NOT NULL,
  PRIMARY KEY (`classroom_id`, `college_id`),
  INDEX `fk_classroom_college1_idx` (`college_id` ASC) VISIBLE,
  CONSTRAINT `fk_classroom_college1`
    FOREIGN KEY (`college_id`)
    REFERENCES `mydb`.`college` (`college_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`labratoary`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`labratoary` (
  `labratoary_id` INT NOT NULL,
  `labratoary_name` VARCHAR(45) NULL,
  `college_id` INT NOT NULL,
  PRIMARY KEY (`labratoary_id`, `college_id`),
  INDEX `fk_labratoary_college1_idx` (`college_id` ASC) VISIBLE,
  CONSTRAINT `fk_labratoary_college1`
    FOREIGN KEY (`college_id`)
    REFERENCES `mydb`.`college` (`college_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`section`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`section` (
  `section_id` INT NOT NULL,
  `course_id` INT NOT NULL,
  `semester` ENUM('1','2') NOT NULL,
  `year` YEAR NOT NULL,
  `time` VARCHAR(60) NOT NULL,
  `classroom_id` INT NULL,
  `college_id` INT NULL,
  `labratoary_id` INT NULL,
  `lab_college_id` INT NULL,
  PRIMARY KEY (`section_id`, `course_id`, `semester`, `year`),
  INDEX `fk_group_course1_idx` (`course_id` ASC) VISIBLE,
  INDEX `fk_section_classroom1_idx` (`classroom_id` ASC, `college_id` ASC) VISIBLE,
  INDEX `fk_section_labratoary1_idx` (`labratoary_id` ASC, `lab_college_id` ASC) VISIBLE,
  CONSTRAINT `fk_group_course1`
    FOREIGN KEY (`course_id`)
    REFERENCES `mydb`.`course` (`co_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_section_classroom1`
    FOREIGN KEY (`classroom_id` , `college_id`)
    REFERENCES `mydb`.`classroom` (`classroom_id` , `college_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_section_labratoary1`
    FOREIGN KEY (`labratoary_id` , `lab_college_id`)
    REFERENCES `mydb`.`labratoary` (`labratoary_id` , `college_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`prerequisite`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`prerequisite` (
  `course1_id` INT NOT NULL,
  `course2_id` INT NOT NULL,
  PRIMARY KEY (`course1_id`, `course2_id`),
  INDEX `fk_course_has_course_course2_idx` (`course2_id` ASC) VISIBLE,
  INDEX `fk_course_has_course_course1_idx` (`course1_id` ASC) VISIBLE,
  CONSTRAINT `fk_course_has_course_course1`
    FOREIGN KEY (`course1_id`)
    REFERENCES `mydb`.`course` (`co_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_course_has_course_course2`
    FOREIGN KEY (`course2_id`)
    REFERENCES `mydb`.`course` (`co_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`invited_professor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`invited_professor` (
  `professor_id` INT NOT NULL,
  `depatment_id` INT NOT NULL,
  `year` YEAR NOT NULL,
  `semester` ENUM('1','2') NOT NULL,
  PRIMARY KEY (`professor_id`, `depatment_id`, `year`, `semester`),
  INDEX `fk_professor_has_depatment_depatment1_idx` (`depatment_id` ASC) VISIBLE,
  INDEX `fk_professor_has_depatment_professor1_idx` (`professor_id` ASC) VISIBLE,
  CONSTRAINT `fk_professor_has_depatment_professor1`
    FOREIGN KEY (`professor_id`)
    REFERENCES `mydb`.`professor` (`idprofessor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_professor_has_depatment_depatment1`
    FOREIGN KEY (`depatment_id`)
    REFERENCES `mydb`.`depatment` (`depatment_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`employee`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`employee` (
  `employee_id` INT NOT NULL,
  `national_id` INT NOT NULL,
  `position` VARCHAR(45) NULL,
  `depatment_id` INT NULL,
  `salary` INT NULL,
  PRIMARY KEY (`employee_id`),
  INDEX `fk_employee_person1_idx` (`national_id` ASC) VISIBLE,
  INDEX `fk_employee_depatment1_idx` (`depatment_id` ASC) VISIBLE,
  CONSTRAINT `fk_employee_person1`
    FOREIGN KEY (`national_id`)
    REFERENCES `mydb`.`person` (`idperson`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_employee_depatment1`
    FOREIGN KEY (`depatment_id`)
    REFERENCES `mydb`.`depatment` (`depatment_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`schedule`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`schedule` (
  `professor_id` INT NOT NULL,
  `section_id` INT NOT NULL,
  `course_id` INT NOT NULL,
  `semester` ENUM('1','2') NOT NULL,
  `year` YEAR NOT NULL,
  `time` VARCHAR(60) NULL,
  PRIMARY KEY (`professor_id`, `section_id`, `course_id`, `semester`, `year`),
  INDEX `fk_professor_has_section_section1_idx` (`section_id` ASC, `course_id` ASC, `semester` ASC, `year` ASC) VISIBLE,
  INDEX `fk_professor_has_section_professor1_idx` (`professor_id` ASC) VISIBLE,
  CONSTRAINT `fk_professor_has_section_professor1`
    FOREIGN KEY (`professor_id`)
    REFERENCES `mydb`.`professor` (`idprofessor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_professor_has_section_section1`
    FOREIGN KEY (`section_id` , `course_id` , `semester` , `year`)
    REFERENCES `mydb`.`section` (`section_id` , `course_id` , `semester` , `year`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`student_has_section`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`student_has_section` (
  `st_id` INT NOT NULL,
  `section_id` INT NOT NULL,
  `course_id` INT NOT NULL,
  `semester` ENUM('1','2') NOT NULL,
  `year` YEAR NOT NULL,
  `grade` DECIMAL(2,2) NULL,
  `deletion` TINYINT(1) NULL DEFAULT false,
  `deletion-type` ENUM('1','2','3','0') NULL,
  PRIMARY KEY (`st_id`, `section_id`, `course_id`, `semester`, `year`),
  INDEX `fk_student_has_section_student1_idx` (`st_id` ASC) VISIBLE,
  INDEX `fk_student_has_section_section1_idx` (`section_id` ASC, `course_id` ASC, `semester` ASC, `year` ASC) VISIBLE,
  CONSTRAINT `fk_student_has_section_student1`
    FOREIGN KEY (`st_id`)
    REFERENCES `mydb`.`student` (`st_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_student_has_section_section1`
    FOREIGN KEY (`section_id` , `course_id` , `semester` , `year`)
    REFERENCES `mydb`.`section` (`section_id` , `course_id` , `semester` , `year`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`branch_library`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`branch_library` (
  `branch_library_id` INT NOT NULL,
  `address` VARCHAR(45) NULL,
  `phone` VARCHAR(45) NULL,
  `university_id` INT NOT NULL,
  `branch_library-name` VARCHAR(45) NULL,
  PRIMARY KEY (`branch_library_id`, `university_id`),
  INDEX `fk_branch_library_university1_idx` (`university_id` ASC) VISIBLE,
  CONSTRAINT `fk_branch_library_university1`
    FOREIGN KEY (`university_id`)
    REFERENCES `mydb`.`university` (`university_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`book`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`book` (
  `book_id` INT NOT NULL,
  `bookname` VARCHAR(45) NULL,
  `author` VARCHAR(100) NULL,
  `publication` VARCHAR(45) NULL,
  `year` YEAR NULL,
  `branch_library_id` INT NOT NULL,
  `university_id` INT NOT NULL,
  PRIMARY KEY (`book_id`, `branch_library_id`),
  INDEX `fk_book_branch_library1_idx` (`branch_library_id` ASC, `university_id` ASC) VISIBLE,
  CONSTRAINT `fk_book_branch_library1`
    FOREIGN KEY (`branch_library_id` , `university_id`)
    REFERENCES `mydb`.`branch_library` (`branch_library_id` , `university_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`lab_assistent`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`lab_assistent` (
  `employee_id` INT NOT NULL,
  `labratoary_labratoary_id` INT NOT NULL,
  `labratoary_college_id` INT NOT NULL,
  INDEX `fk_lab_assistent_employee1_idx` (`employee_id` ASC) VISIBLE,
  PRIMARY KEY (`employee_id`, `labratoary_labratoary_id`, `labratoary_college_id`),
  INDEX `fk_lab_assistent_labratoary1_idx` (`labratoary_labratoary_id` ASC, `labratoary_college_id` ASC) VISIBLE,
  CONSTRAINT `fk_lab_assistent_employee1`
    FOREIGN KEY (`employee_id`)
    REFERENCES `mydb`.`employee` (`employee_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_lab_assistent_labratoary1`
    FOREIGN KEY (`labratoary_labratoary_id` , `labratoary_college_id`)
    REFERENCES `mydb`.`labratoary` (`labratoary_id` , `college_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`master&phd`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`master&phd` (
  `st_id` INT NOT NULL,
  `st_field` VARCHAR(45) NULL,
  PRIMARY KEY (`st_id`),
  CONSTRAINT `fk_bachelor_student1`
    FOREIGN KEY (`st_id`)
    REFERENCES `mydb`.`student` (`st_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`proposal`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`proposal` (
  `proposal_id` INT NOT NULL,
  `title` VARCHAR(45) NULL,
  `st_id` INT NOT NULL,
  PRIMARY KEY (`proposal_id`),
  INDEX `fk_proposal_master1_idx` (`st_id` ASC) VISIBLE,
  CONSTRAINT `fk_proposal_master1`
    FOREIGN KEY (`st_id`)
    REFERENCES `mydb`.`master&phd` (`st_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`professor_diploma`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`professor_diploma` (
  `professor_id` INT NOT NULL,
  `diploma_id` INT NOT NULL,
  `title` ENUM('ba','ma','phd') NULL,
  `from` DATE NULL,
  `to` DATE NULL,
  `university` VARCHAR(45) NULL,
  PRIMARY KEY (`professor_id`, `diploma_id`),
  CONSTRAINT `fk_professor_diploma_professor1`
    FOREIGN KEY (`professor_id`)
    REFERENCES `mydb`.`professor` (`idprofessor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`supervisor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`supervisor` (
  `proposal_id` INT NOT NULL,
  `professor_id` INT NOT NULL,
  PRIMARY KEY (`proposal_id`, `professor_id`),
  INDEX `fk_proposal_has_professor_professor1_idx` (`professor_id` ASC) VISIBLE,
  INDEX `fk_proposal_has_professor_proposal1_idx` (`proposal_id` ASC) VISIBLE,
  CONSTRAINT `fk_proposal_has_professor_proposal1`
    FOREIGN KEY (`proposal_id`)
    REFERENCES `mydb`.`proposal` (`proposal_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_proposal_has_professor_professor1`
    FOREIGN KEY (`professor_id`)
    REFERENCES `mydb`.`professor` (`idprofessor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`arbitration`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`arbitration` (
  `proposal_id` INT NOT NULL,
  `professor_id` INT NOT NULL,
  `proposal_grade` DECIMAL(2,2) NULL,
  PRIMARY KEY (`proposal_id`, `professor_id`),
  INDEX `fk_proposal_has_professor_professor2_idx` (`professor_id` ASC) VISIBLE,
  INDEX `fk_proposal_has_professor_proposal2_idx` (`proposal_id` ASC) VISIBLE,
  CONSTRAINT `fk_proposal_has_professor_proposal2`
    FOREIGN KEY (`proposal_id`)
    REFERENCES `mydb`.`proposal` (`proposal_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_proposal_has_professor_professor2`
    FOREIGN KEY (`professor_id`)
    REFERENCES `mydb`.`professor` (`idprofessor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`hamniaz`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`hamniaz` (
  `course1_id` INT NOT NULL,
  `course2_id` INT NOT NULL,
  PRIMARY KEY (`course1_id`, `course2_id`),
  INDEX `fk_course_has_course_course4_idx` (`course2_id` ASC) VISIBLE,
  INDEX `fk_course_has_course_course3_idx` (`course1_id` ASC) VISIBLE,
  CONSTRAINT `fk_course_has_course_course3`
    FOREIGN KEY (`course1_id`)
    REFERENCES `mydb`.`course` (`co_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_course_has_course_course4`
    FOREIGN KEY (`course2_id`)
    REFERENCES `mydb`.`course` (`co_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`reservation_book`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`reservation_book` (
  `book_id` INT NOT NULL,
  `branch_library_id` INT NOT NULL,
  `st_id` INT NOT NULL,
  `from` DATE NOT NULL,
  `to` DATE NULL,
  `extended` TINYINT(1) NULL DEFAULT false,
  PRIMARY KEY (`book_id`, `branch_library_id`, `st_id`, `from`),
  INDEX `fk_book_has_student_student1_idx` (`st_id` ASC) VISIBLE,
  INDEX `fk_book_has_student_book1_idx` (`book_id` ASC, `branch_library_id` ASC) VISIBLE,
  CONSTRAINT `fk_book_has_student_book1`
    FOREIGN KEY (`book_id` , `branch_library_id`)
    REFERENCES `mydb`.`book` (`book_id` , `branch_library_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_book_has_student_student1`
    FOREIGN KEY (`st_id`)
    REFERENCES `mydb`.`student` (`st_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`book_suggestion`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`book_suggestion` (
  `book_book_id` INT NOT NULL,
  `book_branch_library_id` INT NOT NULL,
  `course_co_id` INT NOT NULL,
  `professor_idprofessor` INT NOT NULL,
  PRIMARY KEY (`book_book_id`, `book_branch_library_id`, `course_co_id`, `professor_idprofessor`),
  INDEX `fk_book_has_course_course1_idx` (`course_co_id` ASC) VISIBLE,
  INDEX `fk_book_has_course_book1_idx` (`book_book_id` ASC, `book_branch_library_id` ASC) VISIBLE,
  INDEX `fk_book_suggestion_professor1_idx` (`professor_idprofessor` ASC) VISIBLE,
  CONSTRAINT `fk_book_has_course_book1`
    FOREIGN KEY (`book_book_id` , `book_branch_library_id`)
    REFERENCES `mydb`.`book` (`book_id` , `branch_library_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_book_has_course_course1`
    FOREIGN KEY (`course_co_id`)
    REFERENCES `mydb`.`course` (`co_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_book_suggestion_professor1`
    FOREIGN KEY (`professor_idprofessor`)
    REFERENCES `mydb`.`professor` (`idprofessor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
