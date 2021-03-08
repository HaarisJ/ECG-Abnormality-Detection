import { useState, useEffect } from "react";
import FetchECGData from "../apis/FetchECGData";
import Graph from "./Graph";
import TSTable from "./TSTable";
import RSTable from "./RSTable";
import { Button, Container } from "react-bootstrap";
import { useAuth } from "../contexts/AuthContext";
import { useHistory } from "react-router-dom";

export default function Dashboard() {
  // STATES
  const [tsFlag, setTsFlag] = useState(true);
  const [graphData, setGraphData] = useState([]);
  const [tsTableEntries, setTsTableEntries] = useState([]);
  const [rsTableEntries, setRsTableEntries] = useState([]);
  const [tsLabels, setTsLabels] = useState({ predict: "", truth: "" });
  const [rsLabels, setRsLabels] = useState({
    sample: 0,
    time: 0,
    condition: "",
  });
  const [selectedClass, setSelectedClass] = useState(0);
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
    setRsLabels({ status: "", condition: "" });
  };

  const testsetBtnHandler = () => {
    setTsFlag(1);
    setGraphData([]);
    setTsLabels({ predict: "", truth: "" });
  };

  const logoutHandler = async () => {
    setError("");
    try {
      console.log("logout handler try hit");
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
      console.log(res.data.data);
      setGraphData(res.data.data);
      setTsLabels({ predict: prediction, truth: truth });
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
    />
  ) : (
    <RSTable entries={rsTableEntries} click={onRsRowClick} />
  );

  const statusIndicators = !tsFlag ? (
    <Container className="d-flex align-items-left justify-content-center">
      <h5 className="text-justify">
        Sample #: <span>{rsLabels.sample}</span>
      </h5>
      <h5 className="text-justify">
        Time Recorded: <span>{rsLabels.time}</span>
      </h5>
      <h5 className="text-justify">
        ECG Condition:{" "}
        <span className="badge bg-success">{rsLabels.condition}</span>
      </h5>
    </Container>
  ) : (
    <div>
      <h5 className="text-justify">
        Predicted Class:{" "}
        {tsLabels.predict === "Normal" ? (
          <span className="badge bg-success">{tsLabels.predict}</span>
        ) : tsLabels.predict === "Abnormal" ? (
          <span className="badge bg-danger">{tsLabels.predict}</span>
        ) : (
          <span className="badge bg-warning">{tsLabels.predict}</span>
        )}
      </h5>
      <h5 className="text-justify">
        Ground Truth:{" "}
        {tsLabels.truth === "Normal" ? (
          <span className="badge bg-success">{tsLabels.truth}</span>
        ) : tsLabels.truth === "Abnormal" ? (
          <span className="badge bg-danger">{tsLabels.truth}</span>
        ) : (
          <span className="badge bg-warning">{tsLabels.truth}</span>
        )}
      </h5>
    </div>
  );

  return (
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
      {/* <Graph vals={graphData} /> */}
      <div className="row">
        <div className="col-md-8">
          <Graph vals={graphData} />
        </div>
        <div className="col-md-4">{table}</div>
        {/* <div className="col-md-4">{table}</div>
        <div className="col-md-8"></div> */}
      </div>
      <Button variant="link" onClick={logoutHandler}>
        Log Out
      </Button>
    </div>
  );
}
