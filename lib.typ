#set page(
  paper: "a4",
  flipped: true,
  margin: 1cm,
)
#set text(font: "IBM Plex Mono", size: 10pt)

#let initial-date = datetime(
  year:  int(sys.inputs.at("year",  default: 2024)),
  month: int(sys.inputs.at("month", default: 11  )),
  day:   int(sys.inputs.at("day",   default: 11  )),
)
#let hours = range(6, 22 + 1)
#assert(initial-date.weekday() == 1, message: "Expected the initial date to be a Monday.")

// Everything below, hopefully, updates dynamically upon changing the above.
#let row-count = 1 + 2*hours.len() + 1
#let dates = range(7).map(i => initial-date + duration(days: i))
#table(
  rows: (auto,) * (row-count - 1) + (1fr,),
  columns: (1/2 * 1fr,) + (1fr,) * 7,
  stroke: (x, y) => {
    if x == 6 and y == row-count - 2 {
      // This hides a little tail that otherwise looks out-of-place.
      (right: none)
    } else if x == 5 {
      (right: 2pt + rgb("#b7b7b7"))
    } else {
      (right: 1pt + rgb("#b7b7b7"))
    }

    if x > 0 and y < row-count - 1 and calc.rem(y, 2) == 1 {
      (bottom: stroke(paint: rgb("#cccccc"), thickness: 0.5pt, dash: "dashed"))
    }
  },

  // Display the dates, along with the weekday names, along the header.
  [],
  ..dates
    .map(d => {
      table.cell(
        [
          #text(size: 7pt, fill: rgb("#666666"))[
            #d.display("[day padding:zero] [month repr:long]")
          ] \
          #text(size: 8pt, fill: rgb("#434343"), weight: "semibold")[
            #upper(d.display("[weekday repr:long]"))
          ]
        ],
        align: center,
      )
    }),

  // For each hour, display a horizontal (dotted) line.
  ..hours
    .map(h => (
      table.cell(
        text(size: 8pt, fill: rgb("#666666"))[
          #if h < 10 {
            "0" + str(h) + ":00"
          } else {
            str(h) + ":00"
          }
        ],
        align: right + horizon,
        inset: (right: 8pt),
        rowspan: 2
      ),
        [], [], [], [], [], [], [],
        [], [], [], [], [], [], [],
    ))
    .flatten(),

  // Use whatever space remains for notes.
  [],
  table.cell(
    text(size: 8pt, fill: rgb("#666666"), weight: "semibold")[NOTES],
    align: bottom
  ),
  [], [], [], [],
  table.cell([], colspan: 2),
)
