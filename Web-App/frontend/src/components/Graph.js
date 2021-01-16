import React from "react";
import { Line } from "react-chartjs-2";

const Graph = (props) => {
  const xlabs = new Array(2000);
  for (let i = 0; i < xlabs.length; i++) {
    let num = 0.2 * i;
    xlabs[i] = num.toFixed(1);
  }

  return (
    <React.Fragment>
      <div className="">
        <Line
          data={{
            labels: xlabs,
            datasets: [
              {
                label: "Voltage (mV)",
                data: props.vals.map((item) => item.value),
                backgroundColor: "rgba(2, 117, 216, 0.0)",
                borderColor: "rgba(2, 117, 216, 0.7)",
                pointBorderColor: "rgba(0,0,0,0)",
                fill: false,
              },
            ],
          }}
          height={300}
          width={600}
          options={{
            maintainAspectRatio: false,
            legend: {
              display: false,
            },
            animation: {
              tension: {
                duration: 3000,
                easing: "linear",
                from: 1,
                to: 0,
                loop: true,
              },
            },
            scales: {
              xAxes: [
                {
                  scaleLabel: {
                    display: true,
                    labelString: "Time (s)",
                  },
                },
              ],
              yAxes: [
                {
                  scaleLabel: {
                    display: true,
                    labelString: "Voltage (mV)",
                  },
                },
              ],
            },
          }}
        />
      </div>
    </React.Fragment>
  );
};

export default Graph;
