const RSTable = (props) => {
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
        style={{ height: "300px", overflow: "auto" }}
      >
        <table className="table table-hover table-sm">
          <thead>
            <tr>
              <th>#</th>
              <th>Time</th>
              <th>Classification</th>
            </tr>
          </thead>
          <tbody>
            {props.entries.map((item) => {
              const prediction = item.label;
              if (prediction === "NSR" && props.tab === 0)
                return (
                  <tr
                    key={item.id}
                    className={
                      props.selectedRow === item.id
                        ? "bg-primary text-white"
                        : ""
                    }
                    onClick={() =>
                      props.click(item.id, item.datetime, "Normal")
                    }
                  >
                    <td>{item.id}</td>
                    <td>{item.datetime}</td>
                    <td>Normal</td>
                  </tr>
                );

              if (prediction === "Other" && props.tab === 1)
                return (
                  <tr
                    key={item.id}
                    className={
                      props.selectedRow === item.id
                        ? "bg-primary text-white"
                        : ""
                    }
                    onClick={() =>
                      props.click(item.id, item.datetime, "Abnormal")
                    }
                  >
                    <td>{item.id}</td>
                    <td>{item.datetime}</td>
                    <td>Abnormal</td>
                  </tr>
                );

              if (prediction === "Noisy" && props.tab === 2)
                return (
                  <tr
                    key={item.id}
                    className={
                      props.selectedRow === item.id
                        ? "bg-primary text-white"
                        : ""
                    }
                    onClick={() => props.click(item.id, item.datetime, "Noisy")}
                  >
                    <td>{item.id}</td>
                    <td>{item.datetime}</td>
                    <td>Noisy</td>
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

export default RSTable;
