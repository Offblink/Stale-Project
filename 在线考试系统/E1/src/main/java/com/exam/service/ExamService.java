package com.exam.service;

import com.exam.dao.AnswerDao;
import com.exam.dao.GradeDao;
import com.exam.dao.QuestionDao;
import com.exam.pojo.Answer;
import com.exam.pojo.Grade;
import com.exam.pojo.Question;

import java.text.SimpleDateFormat;
import java.util.Collections;
import java.util.Date;
import java.util.List;

public class ExamService {
    private AnswerDao answerDao = new AnswerDao();
    private GradeDao gradeDao = new GradeDao();
    private QuestionDao questionDao = new QuestionDao();

    // 1. 获取随机试题（用于学生考试）
    public List<Question> getRandomQuestions(int count) {
        List<Question> allQuestions = questionDao.getAllQuestions();
        // 如果题目数量不足，返回所有题目
        if (allQuestions.size() <= count) {
            return allQuestions;
        }
        // 打乱顺序
        Collections.shuffle(allQuestions);
        // 截取指定数量
        return allQuestions.subList(0, count);
    }

    // 2. 提交答案
    public void submitAnswer(String questionId, String studentUsername, String content) {
        Answer answer = new Answer();
        answer.setQuestionId(questionId);
        answer.setStudentUsername(studentUsername);
        answer.setContent(content);
        // 自动设置提交时间
        answer.setSubmitTime(new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
        answerDao.addAnswer(answer);
    }

    // 3. 获取所有答案
    public List<Answer> getAllAnswers() {
        return answerDao.getAllAnswers();
    }

    // 4. 提交评分
    public void submitGrade(String answerId, String score, String teacherUsername) {
        Grade grade = new Grade();
        grade.setAnswerId(answerId);
        grade.setScore(score);
        grade.setTeacherUsername(teacherUsername);
        gradeDao.addGrade(grade);
    }

    // 5. 获取题目内容（带容错）
    public String getQuestionContent(String questionId) {
        Question q = questionDao.findById(questionId);
        if (q != null) {
            return q.getContent();
        } else {
            return "【该题目已被删除】";
        }
    }

    // 6. 获取评分对象（返回 Grade 对象）
    public Grade getGradeByAnswerId(String answerId) {
        return gradeDao.getAllGrades().stream()
                .filter(g -> g.getAnswerId().equals(answerId))
                .findFirst()
                .orElse(null);
    }

    // 7. 获取所有评分
    public List<Grade> getAllGrades() {
        return gradeDao.getAllGrades();
    }
}
