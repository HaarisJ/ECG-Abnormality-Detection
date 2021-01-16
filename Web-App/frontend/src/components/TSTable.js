import { useState } from "react";

const TSTable = (props) => {
  const [tableState, setTableState] = useState(0);

  return (
    <div>
      <h4>Testset Results</h4>
      <div
        className="table-container"
        style={{ height: "300px", overflow: "auto" }}
      >
        <table className="table table-striped table-hover table-sm">
          <thead>
            <tr>
              <th>#</th>
              <th>Prediction</th>
              <th>Ground Truth</th>
            </tr>
          </thead>
          <tbody>
            {props.entries.map((item) => {
              const prediction = item.label;
              const truth = item.true_lab;
              if (prediction === "NSR" && truth === "NSR\r")
                return (
                  <tr
                    className=""
                    onClick={() => props.click(item.id, "Normal", "Normal")}
                  >
                    <td>{item.id}</td>
                    <td>Normal</td>
                    <td>Normal</td>
                  </tr>
                );
              if (prediction === "NSR" && truth === "Other\r")
                return (
                  <tr
                    className="table-danger"
                    onClick={() => props.click(item.id, "Normal", "Abnormal")}
                  >
                    <td>{item.id}</td>
                    <td>Normal</td>
                    <td>Irregular</td>
                  </tr>
                );
              if (prediction === "NSR" && truth === "Noisy\r")
                return (
                  <tr
                    className="table-danger"
                    onClick={() => props.click(item.id, "Normal", "Noisy")}
                  >
                    <td>{item.id}</td>
                    <td>Normal</td>
                    <td>Noisy</td>
                  </tr>
                );
              if (prediction === "Other" && truth === "Other\r")
                return (
                  <tr
                    className=""
                    onClick={() => props.click(item.id, "Abnormal", "Abnormal")}
                  >
                    <td>{item.id}</td>
                    <td>Irregular</td>
                    <td>Irregular</td>
                  </tr>
                );
              if (prediction === "Other" && truth === "NSR\r")
                return (
                  <tr
                    className="table-danger"
                    onClick={() => props.click(item.id, "Abnormal", "Normal")}
                  >
                    <td>{item.id}</td>
                    <td>Irregular</td>
                    <td>Normal</td>
                  </tr>
                );
              if (prediction === "Other" && truth === "Noisy\r")
                return (
                  <tr
                    className="bg-danger"
                    onClick={() => props.click(item.id, "Abnormal", "Noisy")}
                  >
                    <td>{item.id}</td>
                    <td>Irregular</td>
                    <td>Noisy</td>
                  </tr>
                );
              if (prediction === "Noisy" && truth === "Noisy\r")
                return (
                  <tr
                    className=""
                    onClick={() => props.click(item.id, "Noisy", "Noisy")}
                  >
                    <td>{item.id}</td>
                    <td>Noisy</td>
                    <td>Noisy</td>
                  </tr>
                );
              if (prediction === "Noisy" && truth === "NSR\r")
                return (
                  <tr
                    className="bg-danger"
                    onClick={() => props.click(item.id, "Noisy", "Normal")}
                  >
                    <td>{item.id}</td>
                    <td>Noisy</td>
                    <td>Normal</td>
                  </tr>
                );
              if (prediction === "Noisy" && truth === "Other\r")
                return (
                  <tr
                    className="bg-danger"
                    onClick={() => props.click(item.id, "Noisy", "Abnormal")}
                  >
                    <td>{item.id}</td>
                    <td>Noisy</td>
                    <td>Irregular</td>
                  </tr>
                );
              return (
                <tr className="table-primary">
                  <td>{item.id}</td>
                  <td>{prediction}</td>
                  <td>{truth}</td>
                </tr>
              );
            })}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default TSTable;
