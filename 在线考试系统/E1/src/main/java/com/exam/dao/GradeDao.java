package com.exam.dao;

import com.exam.pojo.Grade;
import com.exam.util.JsonUtil;
import java.util.List;

public class GradeDao {
    public List<Grade> getAllGrades() {
        return JsonUtil.readList("grades.json", Grade.class);
    }

    public void addGrade(Grade grade) {
        List<Grade> grades = getAllGrades();
        grades.add(grade);
        JsonUtil.writeList("grades.json", grades);
    }

    // 根据答案ID列表批量删除评分
    public void deleteByAnswerIds(List<String> answerIds) {
        if (answerIds == null || answerIds.isEmpty()) return;
        List<Grade> grades = getAllGrades();
        grades.removeIf(g -> answerIds.contains(g.getAnswerId()));
        JsonUtil.writeList("grades.json", grades);
    }

    /**
     * 级联更新评分中的教师用户名。
     * 当教师修改用户名时调用此方法，以保证grades.json中的数据关联性。
     *
     */
    public void updateTeacherUsername(String oldUsername, String newUsername) {
        List<Grade> allGrades = getAllGrades();
        boolean isModified = false;

        for (Grade grade : allGrades) {
            if (grade.getTeacherUsername().equals(oldUsername)) {
                grade.setTeacherUsername(newUsername);
                isModified = true;
            }
        }
        if (isModified) {
            JsonUtil.writeList("grades.json", allGrades);
        }
    }
}
