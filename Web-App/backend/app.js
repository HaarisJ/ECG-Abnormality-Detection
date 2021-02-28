require("dotenv").config();
const express = require("express");
const cors = require("cors");
const db = require("./db");

const app = express();

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
  res.send("Reached /realset");
});

app.get("/realset/:id", (req, res) => {
  res.send("Reached /realset/" + req.params.id);
});

const port = process.env.PORT || 3001;
app.listen(port, () => console.log(`Server running on port ${port}`));
