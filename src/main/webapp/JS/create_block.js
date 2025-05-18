function submitStudents() {
  const rows = document.querySelectorAll("#studentTable tbody tr");
  const studentData = [];

  rows.forEach((row, index) => {
    const inputs = row.querySelectorAll("input[type='text']");
    const checkbox = row.querySelector("input[type='checkbox']");

    const student = {
      name: inputs[0].value.trim(),
      rollNo: inputs[1].value.trim(),
      div: inputs[2].value.trim(),
      ernNo: inputs[3].value.trim(),
      attendance: checkbox.checked ? "Present" : "Absent"
    };

    studentData.push(student);
  });

  console.log("Submitted Student Data:", studentData);
  alert("Student data submitted. Check console for details.");
}

function showStudentTable() {
  const table = document.getElementById("studentTable");
  const submitBtn = document.getElementById("submitBtn");

  table.style.display = "table";
  submitBtn.style.display = "block";
}
