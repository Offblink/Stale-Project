package com.exam.service;

import com.exam.dao.AnswerDao;
import com.exam.dao.GradeDao;
import com.exam.dao.QuestionDao;
import com.exam.pojo.Answer;
import com.exam.pojo.Question;

import java.util.List;
import java.util.stream.Collectors;

public class QuestionService {
    private QuestionDao questionDao = new QuestionDao();
    private AnswerDao answerDao = new AnswerDao();
    private GradeDao gradeDao = new GradeDao();

    public List<Question> getAllQuestions() {
        return questionDao.getAllQuestions();
    }

    public List<Question> getRandomQuestions(int count) {
        List<Question> allQuestions = questionDao.getAllQuestions();
        if (allQuestions.size() <= count) return allQuestions;
        java.util.Collections.shuffle(allQuestions);
        return allQuestions.subList(0, count);
    }

    public void addQuestion(Question question) {
        questionDao.addQuestion(question);
    }

    // 完善的删除方法：带级联
    public void deleteQuestion(String id) {
        // 1. 找关联答案
        List<Answer> answers = answerDao.findByQuestionId(id);
        List<String> answerIds = answers.stream().map(Answer::getId).collect(Collectors.toList());

        // 2. 删评分
        if (!answerIds.isEmpty()) {
            gradeDao.deleteByAnswerIds(answerIds);
        }
        // 3. 删答案
        answerDao.deleteByQuestionId(id);
        // 4. 删题目
        questionDao.deleteQuestion(id);
    }

    public void updateQuestion(Question question) {
        questionDao.updateQuestion(question);
    }

    public List<Question> searchQuestions(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return getAllQuestions();
        }
        return getAllQuestions().stream()
                .filter(q -> q.getContent().contains(keyword))
                .collect(Collectors.toList());
    }
}
