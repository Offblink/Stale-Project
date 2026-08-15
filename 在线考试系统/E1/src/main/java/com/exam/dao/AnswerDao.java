package com.exam.dao;

import com.exam.pojo.Answer;
import com.exam.util.JsonUtil;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

public class AnswerDao {
    public List<Answer> getAllAnswers() {
        return JsonUtil.readList("answers.json", Answer.class);
    }

    public void addAnswer(Answer answer) {
        List<Answer> answers = getAllAnswers();
        if (answer.getId() == null || answer.getId().isEmpty()) {
            answer.setId(UUID.randomUUID().toString());
        }
        answers.add(answer);
        JsonUtil.writeList("answers.json", answers);
    }

    // 新增：根据题目ID查找答案
    public List<Answer> findByQuestionId(String questionId) {
        return getAllAnswers().stream()
                .filter(a -> a.getQuestionId().equals(questionId))
                .collect(Collectors.toList());
    }

    // 新增：根据题目ID删除答案
    public void deleteByQuestionId(String questionId) {
        List<Answer> answers = getAllAnswers();
        answers.removeIf(a -> a.getQuestionId().equals(questionId));
        JsonUtil.writeList("answers.json", answers);
    }

    /**
     * 级联更新答案中的学生用户名。
     * 当学生修改用户名时调用此方法，以保证answers.json中的数据关联性。
     *
     */
    public void updateStudentUsername(String oldUsername, String newUsername) {
        List<Answer> allAnswers = getAllAnswers();
        // 标记是否有数据被修改，用于优化写文件操作
        boolean isModified = false;

        // 对于答案表中的数据，遍历后依次修改用户名
        for (Answer answer : allAnswers) {
            if (answer.getStudentUsername().equals(oldUsername)) {
                answer.setStudentUsername(newUsername);
                isModified = true;
            }
        }
        // 只有当数据确实发生变更时，才写入文件
        if (isModified) {
            JsonUtil.writeList("answers.json", allAnswers);
        }
    }
}
