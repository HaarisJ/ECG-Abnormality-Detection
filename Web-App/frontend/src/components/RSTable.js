import React from "react";

const RSTable = (props) => {
  return (
    <div className="container">
      <hr></hr>
      <h2>Realtime Results</h2>
      <table className="table table-hover">
        <thead>
          <tr>
            <th>#</th>
            <th>Time</th>
            <th>Classification</th>
          </tr>
        </thead>
        <tbody>
          <tr className="table-danger">
            <td>1</td>
            <td>4:46.10pm</td>
            <td>Normal</td>
            {/* <td>Irregular</td> */}
          </tr>
          <tr className="table-success">
            <td>2</td>
            <td>4:46.40pm</td>
            <td>Abnormal</td>
          </tr>
        </tbody>
      </table>
    </div>
  );
};

export default RSTable;
