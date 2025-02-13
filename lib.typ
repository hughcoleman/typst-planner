#let planner(
  initial-date: datetime,
  events: (),
  paper: "a4",
) = {
  set text(font: "IBM Plex Mono", size: 10pt)

  let min-h = 6
  let max-h = 22
  let planner-cells = (
    for r0 in range(-1, max-h - min-h + 2) {
      if r0 == -1 {
        /* Header */
        for c in (-1, 0, 1, 2, 3, 4, 5, 6) {
          if c == -1 {
            ([],)
          } else {
            let d = initial-date + duration(days: c)
            (
              table.cell(
                [
                  #text(size: 7pt, fill: rgb("#666666"))[
                    #d.display("[day padding:zero] [month repr:long]")
                  ] \
                  #text(size: 8pt, fill: rgb("#434343"), weight: "semibold")[
                    #upper(d.display("[weekday]"))
                  ]
                ],
                align: center,
              ),
            )
          }
        }
      } else if (r0 <= max-h - min-h) {
        /* Body */
        for r in (0, 1) {
          for c in (-1, 0, 1, 2, 3, 4, 5, 6) {
            if c == -1 {
              /* Gutter */
              if r == 0 {
                let h = min-h + r0
                (
                  table.cell(
                    text(
                      size: 8pt,
                      fill: rgb("#666666"),
                      if h < 10 {
                        [0#h:00]
                      } else {
                        [#h:00]
                      },
                    ),
                    align: right + horizon,
                    inset: (right: 8pt),
                    rowspan: 2,
                  ),
                )
              } else {
                (none,)
              }
            } else {
              /* Cell */
              let weekday-name = (initial-date + duration(days: c)).display("[weekday]")
              let hour = min-h + r0 + r - 1

              // Determine the event, if any, this cell should show.
              let event = events.find(
                event => event.on == weekday-name and event.from <= hour and event.to > hour
              )

              if (r0 == 0 and r == 0) or (r0 == max-h - min-h and r == 1) {
                ([],)
              } else if (r == 1 and (event == none or event.from == hour)) {
                let rowspan = if event == none { 2 } else {
                  2 * (event.to - event.from)
                }
                let label = if event == none { "" } else {
                  event.name
                }

                (
                  table.cell(
                    text(size: 8pt, fill: rgb("#444444"))[#label],
                    fill: if event == none { none } else { rgb("#dfdfdf") },
                    stroke: (
                      top: stroke(paint: rgb("#cccccc"), thickness: 0.5pt, dash: "dashed"),
                      bottom: stroke(paint: rgb("#cccccc"), thickness: 0.5pt, dash: "dashed")
                    ),
                    rowspan: rowspan,
                  ),
                )
              } else {
                (none,)
              }
            }
          }
        }
      } else {
        /* Footer */
        (
          [],
          table.cell(
            text(size: 8pt, fill: rgb("#666666"), weight: "semibold")[NOTES],
            align: bottom
          ),
          [], [], [], [],
          table.cell([], colspan: 2),
        )
      }
    }
      .filter(c => c != none)
  )

  table(
    rows: (auto,) + (0.3fr,) * ((max-h - min-h + 1) * 2) + (4fr,),
    columns: (0.5fr,) + (1fr,) * 7,
    stroke: (x, y) => {
      if x == 6 and y == 2*(max-h - min-h + 1) {
        // This hides a little tail that otherwise looks out-of-place.
        (right: none)
      } else if x == 5 {
        (right: 2pt + rgb("#b7b7b7"))
      } else {
        (right: 1pt + rgb("#b7b7b7"))
      }
    },
    ..planner-cells,
  )
}
