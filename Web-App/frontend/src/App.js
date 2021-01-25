import { useState, useEffect } from "react";
import { BrowserRouter } from "react-router-dom";

import "./App.css";
import Graph from "./components/Graph";
import FetchECGData from "./apis/FetchECGData";
import TSTable from "./components/TSTable";
import RSTable from "./components/RSTable";

const App = () => {
  // Create toggle button here, switch between which component is rendered
  // Realtime component vs Testset component
  // The state will be managed here
  // MySQL queries will be made here depending on testset or realtime state

  // STATES
  const [tsFlag, setTsFlag] = useState(true);
  const [graphData, setGraphData] = useState([]);
  const [tsTableEntries, setTsTableEntries] = useState([]);
  const [rsTableEntries, setRsTableEntries] = useState([]);
  const [ecgState, setEcgState] = useState({ predict: "", truth: "" });
  const [appStatus, setAppStatus] = useState("Waiting for new data");
  const [selectedClass, setSelectedClass] = useState(0);

  // SETUP
  useEffect(() => {
    const fetchTsData = async () => {
      try {
        const res = await FetchECGData.get("/testset");
        setTsTableEntries(res.data.data);
        // console.log(data);
      } catch (err) {
        console.log(err);
      }
    };
    const fetchRsData = async () => {
      try {
        const res = await FetchECGData.get("/realset");
        setRsTableEntries(res.data.data);
        // console.log(data);
      } catch (err) {
        console.log(err);
      }
    };
    fetchTsData();
    fetchRsData();
  }, []);

  const realtimeBtnHandler = () => {
    setTsFlag(0);
  };

  const testsetBtnHandler = () => {
    setTsFlag(1);
  };

  const onRowClick = async (id, prediction, truth) => {
    try {
      // console.log(id);
      const res = await FetchECGData.get(`/testset/${id}`);
      setGraphData(res.data.data);
      setEcgState({ predict: prediction, truth: truth });
      // console.log(data);
    } catch (err) {
      console.log(err);
    }
  };

  const tableClassHandler = (classInput) => {
    setSelectedClass(classInput);
  };

  const table = tsFlag ? (
    <TSTable
      entries={tsTableEntries}
      click={onRowClick}
      tab={selectedClass}
      changeClass={tableClassHandler}
    />
  ) : (
    <RSTable entries={tsTableEntries} click={onRowClick} />
  );

  const statusIndicators = !tsFlag ? (
    <div>
      <h5 className="text-justify">
        Status: <span className="badge bg-primary">{appStatus}</span>
      </h5>
      <h5 className="text-justify">
        ECG Condition: <span className="badge bg-success">Normal</span>
      </h5>
    </div>
  ) : (
    <div>
      <h5 className="text-justify">
        Predicted Class:{" "}
        {ecgState.predict === "Normal" ? (
          <span className="badge bg-success">{ecgState.predict}</span>
        ) : ecgState.predict === "Abnormal" ? (
          <span className="badge bg-danger">{ecgState.predict}</span>
        ) : (
          <span className="badge bg-warning">{ecgState.predict}</span>
        )}
      </h5>
      <h5 className="text-justify">
        Ground Truth:{" "}
        {ecgState.truth === "Normal" ? (
          <span className="badge bg-success">{ecgState.truth}</span>
        ) : ecgState.truth === "Abnormal" ? (
          <span className="badge bg-danger">{ecgState.truth}</span>
        ) : (
          <span className="badge bg-warning">{ecgState.truth}</span>
        )}
      </h5>
    </div>
  );

  return (
    <BrowserRouter>
      <div className="App container-sm">
        <h1>ECG Abnormality Detection</h1>
        <div className="btn-group">
          <button
            className={
              tsFlag
                ? "btn btn-outline-primary"
                : "btn btn-outline-primary active"
            }
            onClick={realtimeBtnHandler}
          >
            Realtime
          </button>

          <button
            className={
              tsFlag
                ? "btn btn-outline-primary active"
                : "btn btn-outline-primary"
            }
            onClick={testsetBtnHandler}
          >
            Testset
          </button>
        </div>
        {statusIndicators}
        <Graph vals={graphData} />
        <div className="row">
          <div className="col-md-4">{table}</div>
          <div className="col-md-8"></div>
        </div>
      </div>
    </BrowserRouter>
  );
};

export default App;
