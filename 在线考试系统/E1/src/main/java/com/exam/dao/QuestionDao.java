package com.exam.dao;

import com.exam.pojo.Question;
import com.exam.util.JsonUtil;
import java.util.List;
import java.util.UUID;

public class QuestionDao {
    public List<Question> getAllQuestions() {
        return JsonUtil.readList("questions.json", Question.class);
    }

    public void addQuestion(Question question) {
        List<Question> questions = getAllQuestions();
        if (question.getId() == null || question.getId().isEmpty()) {
            question.setId(UUID.randomUUID().toString());
        }
        questions.add(question);
        JsonUtil.writeList("questions.json", questions);
    }

    public void deleteQuestion(String id) {
        List<Question> questions = getAllQuestions();
        questions.removeIf(q -> q.getId().equals(id));
        JsonUtil.writeList("questions.json", questions);
    }

    public void updateQuestion(Question question) {
        List<Question> questions = getAllQuestions();
        for (int i = 0; i < questions.size(); i++) {
            if (questions.get(i).getId().equals(question.getId())) {
                questions.set(i, question);
                break;
            }
        }
        JsonUtil.writeList("questions.json", questions);
    }

    public Question findById(String id) {
        return getAllQuestions().stream()
                .filter(q -> q.getId().equals(id))
                .findFirst()
                .orElse(null);
    }
}
