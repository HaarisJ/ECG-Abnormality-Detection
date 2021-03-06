require("dotenv").config();
const express = require("express");
const cors = require("cors");
const db = require("./db");

const app = express();
const { spawn } = require("child_process");

app.use(cors());
app.use(express.json());

//ROUTES
app.get("/", (req, res) => {
  res.send("Welcome to Home");
});

app.get("/testset", (req, res) => {
  try {
    db.query("SELECT * FROM testset", (err, result) => {
      res.status(200).json({
        numResults: result.length,
        data: result,
      });
    });
  } catch (err) {
    console.log(err);
  }
});

app.get("/testset/:id", (req, res) => {
  const id = req.params.id;
  try {
    db.query(
      `SELECT * FROM testset INNER JOIN testset_data ON testset.id = testset_data.id WHERE testset.id=${id}`,
      (err, result) => {
        res.status(200).json({
          // numResults: result.length,
          data: result,
        });
      }
    );
  } catch (err) {
    console.log(err);
  }
});

app.get("/realset", (req, res) => {
  try {
    db.query("SELECT * FROM realset", (err, result) => {
      res.status(200).json({
        numResults: result.length,
        data: result,
      });
    });
  } catch (err) {
    console.log(err);
  }
});

app.get("/realset/:id", (req, res) => {
  const id = req.params.id;

  try {
    db.query(
      `SELECT * FROM realset INNER JOIN realset_data ON realset.id = realset_data.id WHERE realset.id=${id}`,
      (err, result) => {
        let dataGet = "";
        // spawn new child process to call the python script
        // const python = spawn("python", ["ecg_filter.py"]);
        const python = spawn("python", ["ecg_filter.py"]);

        // collect data from script
        python.stdout.on("data", function (data) {
          console.log("Pipe data from python script ...");
          dataGet += data.toString();
        });

        // in close event we are sure that stream from child process is closed
        python.stdout.on("end", (code) => {
          console.log(`child process close all stdio with code ${code}`);
          res.status(200).json({
            data: JSON.parse(dataGet),
            // data: dataGet,
          });
        });
        //send unfiltered data from db to python subprocess
        python.stdin.write(
          // JSON.stringify(result.map((x) => x.value * (3.3 / 4096)))
          JSON.stringify(result.map((x) => x.value))
          // JSON.stringify()
        );
        python.stdin.end();
      }
    );
  } catch (err) {
    console.log(err);
  }
});

const port = process.env.PORT || 3001;
app.listen(port, () => console.log(`Server running on port ${port}`));
