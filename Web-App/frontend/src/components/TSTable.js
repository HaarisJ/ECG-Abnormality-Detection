const TSTable = (props) => {
  return (
    <div>
      <div className="btn-group container">
        <button
          className={
            props.tab === 0
              ? "btn btn-outline-success active"
              : "btn btn-outline-success"
          }
          onClick={() => props.changeClass(0)}
        >
          Normal
        </button>

        <button
          className={
            props.tab === 1
              ? "btn btn-outline-danger active"
              : "btn btn-outline-danger"
          }
          onClick={() => props.changeClass(1)}
        >
          Abnormal
        </button>
        <button
          className={
            props.tab === 2
              ? "btn btn-outline-warning active"
              : "btn btn-outline-warning"
          }
          onClick={() => props.changeClass(2)}
        >
          Noisy
        </button>
      </div>
      <div
        className="table-container"
        style={{ height: "400px", overflow: "auto", margin: "10px 10px 100px" }}
      >
        <table className="table table-hover table-sm">
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
              if (prediction === "NSR" && truth === "NSR\r" && props.tab === 0)
                return (
                  <tr
                    key={item.id}
                    className={
                      props.selectedRow === item.id
                        ? "bg-primary text-white"
                        : ""
                    }
                    onClick={() => props.click(item.id, "Normal", "Normal")}
                  >
                    <td>{item.id}</td>
                    <td>Normal</td>
                    <td>Normal</td>
                  </tr>
                );
              if (
                prediction === "NSR" &&
                truth === "Other\r" &&
                props.tab === 0
              )
                return (
                  <tr
                    key={item.id}
                    className={
                      props.selectedRow === item.id
                        ? "bg-primary text-white"
                        : "table-danger"
                    }
                    onClick={() => props.click(item.id, "Normal", "Abnormal")}
                  >
                    <td>{item.id}</td>
                    <td>Normal</td>
                    <td>Abnormal</td>
                  </tr>
                );
              if (
                prediction === "NSR" &&
                truth === "Noisy\r" &&
                props.tab === 0
              )
                return (
                  <tr
                    key={item.id}
                    className={
                      props.selectedRow === item.id
                        ? "bg-primary text-white"
                        : "table-danger"
                    }
                    onClick={() => props.click(item.id, "Normal", "Noisy")}
                  >
                    <td>{item.id}</td>
                    <td>Normal</td>
                    <td>Noisy</td>
                  </tr>
                );
              if (
                prediction === "Other" &&
                truth === "Other\r" &&
                props.tab === 1
              )
                return (
                  <tr
                    key={item.id}
                    className={
                      props.selectedRow === item.id
                        ? "bg-primary text-white"
                        : ""
                    }
                    onClick={() => props.click(item.id, "Abnormal", "Abnormal")}
                  >
                    <td>{item.id}</td>
                    <td>Abnormal</td>
                    <td>Abnormal</td>
                  </tr>
                );
              if (
                prediction === "Other" &&
                truth === "NSR\r" &&
                props.tab === 1
              )
                return (
                  <tr
                    key={item.id}
                    className={
                      props.selectedRow === item.id
                        ? "bg-primary text-white"
                        : "table-danger"
                    }
                    onClick={() => props.click(item.id, "Abnormal", "Normal")}
                  >
                    <td>{item.id}</td>
                    <td>Abnormal</td>
                    <td>Normal</td>
                  </tr>
                );
              if (
                prediction === "Other" &&
                truth === "Noisy\r" &&
                props.tab === 1
              )
                return (
                  <tr
                    key={item.id}
                    className={
                      props.selectedRow === item.id
                        ? "bg-primary text-white"
                        : "table-danger"
                    }
                    onClick={() => props.click(item.id, "Abnormal", "Noisy")}
                  >
                    <td>{item.id}</td>
                    <td>Abnormal</td>
                    <td>Noisy</td>
                  </tr>
                );
              if (
                prediction === "Noisy" &&
                truth === "Noisy\r" &&
                props.tab === 2
              )
                return (
                  <tr
                    key={item.id}
                    className={
                      props.selectedRow === item.id
                        ? "bg-primary text-white"
                        : ""
                    }
                    onClick={() => props.click(item.id, "Noisy", "Noisy")}
                  >
                    <td>{item.id}</td>
                    <td>Noisy</td>
                    <td>Noisy</td>
                  </tr>
                );
              if (
                prediction === "Noisy" &&
                truth === "NSR\r" &&
                props.tab === 2
              )
                return (
                  <tr
                    key={item.id}
                    className={
                      props.selectedRow === item.id
                        ? "bg-primary text-white"
                        : "table-danger"
                    }
                    onClick={() => props.click(item.id, "Noisy", "Normal")}
                  >
                    <td>{item.id}</td>
                    <td>Noisy</td>
                    <td>Normal</td>
                  </tr>
                );
              if (
                prediction === "Noisy" &&
                truth === "Other\r" &&
                props.tab === 2
              )
                return (
                  <tr
                    key={item.id}
                    className="table-danger"
                    onClick={() => props.click(item.id, "Noisy", "Abnormal")}
                  >
                    <td>{item.id}</td>
                    <td>Noisy</td>
                    <td>Abnormal</td>
                  </tr>
                );
              return undefined;
            })}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default TSTable;
