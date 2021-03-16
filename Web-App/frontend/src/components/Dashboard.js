import { useState, useEffect } from "react";
import FetchECGData from "../apis/FetchECGData";
import Graph from "./Graph";
import TSTable from "./TSTable";
import RSTable from "./RSTable";
import StatusIndicators from "./StatusIndicators";
import { Button, Alert } from "react-bootstrap";
import { useAuth } from "../contexts/AuthContext";
import { useHistory } from "react-router-dom";

export default function Dashboard() {
  // STATES
  const [tsFlag, setTsFlag] = useState(true);
  const [showAbnormalDetected, setShowAbnormalDetected] = useState(true);
  const [graphData, setGraphData] = useState([]);
  const [tsTableEntries, setTsTableEntries] = useState([]);
  const [rsTableEntries, setRsTableEntries] = useState([]);
  const [tsLabels, setTsLabels] = useState({
    sample: 0,
    predict: "",
    truth: "",
  });
  const [rsLabels, setRsLabels] = useState({
    sample: 0,
    time: 0,
    condition: "",
  });
  const [selectedClass, setSelectedClass] = useState(0);
  const [selectedRowId, setSelectedRowId] = useState(0);
  const [error, setError] = useState("");
  const { logout } = useAuth();
  const history = useHistory();

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
    setGraphData([]);
    setSelectedRowId(0);
    setRsLabels({ sample: "", time: "", condition: "" });
  };

  const testsetBtnHandler = () => {
    setTsFlag(1);
    setGraphData([]);
    setSelectedRowId(0);
    setTsLabels({ sample: "", predict: "", truth: "" });
  };

  const logoutHandler = async () => {
    setError("");
    try {
      await logout();
      history.push("/login");
    } catch {
      setError("Failed to log out");
    }
  };

  const onTsRowClick = async (id, prediction, truth) => {
    try {
      // console.log(id);
      const res = await FetchECGData.get(`/testset/${id}`);
      setGraphData(res.data.data);
      setTsLabels({ sample: id, predict: prediction, truth: truth });
      setSelectedRowId(id);
      // console.log(data);
    } catch (err) {
      console.log(err);
    }
  };

  const onRsRowClick = async (id, datetime, prediction) => {
    try {
      // console.log(id);
      const res = await FetchECGData.get(`/realset/${id}`);
      setGraphData(res.data.data);
      setSelectedRowId(id);
      setRsLabels({
        sample: id,
        time: datetime,
        condition: prediction,
      });
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
      click={onTsRowClick}
      tab={selectedClass}
      changeClass={tableClassHandler}
      selectedRow={selectedRowId}
    />
  ) : (
    <RSTable
      entries={rsTableEntries}
      click={onRsRowClick}
      tab={selectedClass}
      changeClass={tableClassHandler}
      selectedRow={selectedRowId}
    />
  );

  return (
    <div className="App mx-4">
      <h1 className="mt-4">ECG Abnormality Detection</h1>
      <h5 className="mt-1">A Capstone Project By Group 25</h5>
      {error && <Alert variant="danger">{error}</Alert>}
      {showAbnormalDetected &&
      rsTableEntries.some((reading) => reading.label === "Other") ? (
        <div
          className="alert alert-warning alert-dismissible fade show"
          role="alert"
        >
          Abnormal ECG Detected!
          <button
            type="button"
            className="btn-close"
            data-bs-dismiss="alert"
            aria-label="Close"
            onClick={() => setShowAbnormalDetected(false)}
          ></button>
        </div>
      ) : null}
      <div className="btn-group w-25 mt-3">
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
      <StatusIndicators
        tsFlag={tsFlag}
        tsLabels={tsLabels}
        rsLabels={rsLabels}
      />
      {/* <Graph vals={graphData} /> */}
      <div className="row">
        <div className="col-md-9">
          <Graph vals={graphData} />
        </div>
        <div className="col-md-3">{table}</div>
        {/* <div className="col-md-4">{table}</div>
        <div className="col-md-8"></div> */}
      </div>
      <Button className="mt-5" variant="link" onClick={logoutHandler}>
        Log Out
      </Button>
    </div>
  );
}
