import { Container } from "react-bootstrap";

export default function StatusIndicators(props) {
  const statusIndicators = !props.tsFlag ? (
    <Container className="d-flex flex-column align-items-start mx-5">
      <h5 className="text-justify">
        Sample: <span>{props.rsLabels.sample}</span>
      </h5>
      <h5 className="text-justify">
        Time Recorded: <span>{props.rsLabels.time}</span>
      </h5>
      <h5 className="text-justify">
        ECG Condition:{" "}
        <span className="badge bg-success">{props.rsLabels.condition}</span>
      </h5>
    </Container>
  ) : (
    <div className="d-flex flex-column align-items-start mx-5">
      <h5 className="text-justify">
        Sample: <span>{props.tsLabels.sample}</span>
      </h5>
      <h5 className="text-justify">
        Predicted Class:{" "}
        {props.tsLabels.predict === "Normal" ? (
          <span className="badge bg-success">{props.tsLabels.predict}</span>
        ) : props.tsLabels.predict === "Abnormal" ? (
          <span className="badge bg-danger">{props.tsLabels.predict}</span>
        ) : (
          <span className="badge bg-warning">{props.tsLabels.predict}</span>
        )}
      </h5>
      <h5 className="text-justify">
        Ground Truth:{" "}
        {props.tsLabels.truth === "Normal" ? (
          <span className="badge bg-success">{props.tsLabels.truth}</span>
        ) : props.tsLabels.truth === "Abnormal" ? (
          <span className="badge bg-danger">{props.tsLabels.truth}</span>
        ) : (
          <span className="badge bg-warning">{props.tsLabels.truth}</span>
        )}
      </h5>
    </div>
  );
  return <div>{statusIndicators}</div>;
}
