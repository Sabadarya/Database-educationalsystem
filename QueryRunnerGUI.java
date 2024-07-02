import java.sql.*;
import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
public class QueryRunnerGUI {
    private static final String[] QUERIES = {
            "SELECT * FROM student_has_section;",
            "SELECT s.course_id, COUNT(DISTINCT s.st_id) as num_students\n" +
                    "FROM student_has_section s\n" +
                    "GROUP BY s.course_id\n" +
                    "HAVING num_students > 0;\n",
            "SELECT s.st_id, ROUND(SUM(s.grade * cc.credit) / SUM(cc.credit), 2) AS weighted_avg_grade\n" +
                    "FROM student_has_section s\n" +
                    "JOIN section se ON s.section_id = se.section_id\n" +
                    "JOIN course cc ON se.course_id = cc.co_id\n" +
                    "GROUP BY s.st_id;\n",
            "SELECT p.*\n" +
                    "FROM professor p\n" +
                    "JOIN (\n" +
                    " SELECT professor_id, SUM(credit) AS total_credits\n" +
                    " FROM schedule s\n" +
                    " JOIN course cc ON s.course_id = cc.co_id\n" +
                    " GROUP BY professor_id\n" +
                    ") AS t ON p.idprofessor = t.professor_id\n" +
                    "WHERE total_credits > 2;\n",
            "Select bookname\n" +
                    "from book\n" +
                    "where book_id in(\n" +
                    "select book_id\n" +
                    "from reservation_book \n" +
                    "Where book.book_id=reservation_book.book_id\n" +
                    "Group by book_id\n" +

                    "Having count(*)>3); \n",
            "SELECT schedule.*\n" +
                    "FROM schedule \n" +
                    "JOIN (\n" +
                    " SELECT shs.section_id, shs.course_id, shs.semester, shs.`year`, COUNT(shs.st_id) AS student_count\n" +
                    " FROM student_has_section shs\n" +
                    " GROUP BY shs.section_id, shs.course_id, shs.semester, shs.`year`\n" +
                    " HAVING student_count >= 0\n" +
                    ") AS filtered_sections\n" +
                    "ON schedule.section_id = filtered_sections.section_id\n" +
                    "AND schedule.course_id = filtered_sections.course_id\n" +
                    "AND schedule.semester = filtered_sections.semester\n" +
                    "AND schedule.`year` = filtered_sections.`year`\n" +
                    "JOIN (\n" +
                    " SELECT s.professor_id\n" +
                    " FROM schedule s\n" +
                    " GROUP BY s.professor_id\n" +
                    " HAVING COUNT(DISTINCT s.course_id) > 0\n" +
                    ") AS filtered_professors\n" +
                    "ON schedule.professor_id = filtered_professors.professor_id;",
            "Select *\n" +
                    "From student join person on student.national_id=person.idperson\n" +
                    "Where st_id not in (select st_id\n" +
                    "From student_has_section);\n"
    };

    public static void main(String[] args) {
        JFrame frame = new JFrame("Query Runner");
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setSize(400, 300);
        frame.setLayout(new GridLayout(7, 1));

        for (int i = 0; i < QUERIES.length; i++) {

            int queryIndex = i;
            JButton button = new JButton("Query " + (i + 1));
            button.addActionListener(new ActionListener() {
                @Override
                public void actionPerformed(ActionEvent e) {
                    executeQuery(QUERIES[queryIndex]);
                }
            });
            frame.add(button);
        }

        frame.setVisible(true);
    }

    private static void executeQuery(String query) {
        try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mydb", "root", "saba1234");
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            ResultSetMetaData metadata = rs.getMetaData();
            int columnCount = metadata.getColumnCount();
            StringBuilder result = new StringBuilder("Query results:\n");

            while (rs.next()) {
                for (int i = 1; i <= columnCount; i++) {
                    if (i > 1) result.append(", ");
                    result.append(rs.getObject(i));
                }
                result.append("\n");
            }

            JTextArea textArea = new JTextArea(result.toString());
            JScrollPane scrollPane = new JScrollPane(textArea);
            JFrame resultFrame = new JFrame("Query Result");
            resultFrame.setSize(500, 400);

            resultFrame.add(scrollPane);
            resultFrame.setVisible(true);

        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Error executing the query: " + e.getMessage());
        }
    }
}
