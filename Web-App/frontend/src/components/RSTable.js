const RSTable = (props) => {
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
              <th>Time</th>
              <th>Classification</th>
            </tr>
          </thead>
          <tbody>
            {props.entries.map((item) => {
              const prediction = item.label;
              if (prediction === "NSR")
                return (
                  <tr
                    key={item.id}
                    className=""
                    onClick={() =>
                      props.click(item.id, item.datetime, "Normal")
                    }
                  >
                    <td>{item.id}</td>
                    <td>{item.datetime}</td>
                    <td>Normal</td>
                  </tr>
                );

              if (prediction === "Other")
                return (
                  <tr
                    key={item.id}
                    className=""
                    onClick={() =>
                      props.click(item.id, item.datetime, "Abnormal")
                    }
                  >
                    <td>{item.id}</td>
                    <td>{item.datetime}</td>
                    <td>Irregular</td>
                  </tr>
                );

              if (prediction === "Noisy")
                return (
                  <tr
                    key={item.id}
                    className=""
                    onClick={() => props.click(item.id, item.datetime, "Noisy")}
                  >
                    <td>{item.id}</td>
                    <td>{item.datetime}</td>
                    <td>Noisy</td>
                  </tr>
                );

              return (
                <tr key={item.id} className="table-danger">
                  <td>{item.id}</td>
                  <td>{item.datetime}</td>
                  <td>{prediction}</td>
                </tr>
              );
            })}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default RSTable;
