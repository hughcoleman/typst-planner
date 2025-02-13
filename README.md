# typst-planner

A simple weekly planner for Typst

## Example

```typst
#import "lib.typ": planner

// The landscape orientation usually looks better.
#set page(paper: "a4", flipped: true, margin: 1cm)

#planner(
  initial-date: datetime(year: 2025, month: 2, day: 10),
  events: (
    ( name: "MATH 101", on: "Monday",    from: 12, to: 14 ),
    ( name: "MATH 102", on: "Tuesday",   from:  8, to: 10 ),
    ( name: "MATH 103", on: "Tuesday",   from: 10, to: 12 ),
    ( name: "MATH 101", on: "Thursday",  from:  9, to: 12 ),
  ),
)
```
