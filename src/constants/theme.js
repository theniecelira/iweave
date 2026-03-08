export const MAROON = "#7A1530";
export const MAROON_DARK = "#5A0F22";
export const MAROON_LIGHT = "#9B2040";
export const LAVENDER = "#ECEAF4";
export const ORANGE = "#FF6B00";
export const WHITE = "#FFFFFF";

export const styles = {
  phoneFrame: {
    width: 390,
    height: 780,
    background: WHITE,
    borderRadius: 40,
    overflow: "hidden",
    boxShadow:
      "0 40px 80px rgba(0,0,0,0.4), 0 0 0 10px #1a1a1a, 0 0 0 12px #333",
    position: "relative",
    display: "flex",
    flexDirection: "column",
  },
  screen: {
    flex: 1,
    overflow: "hidden",
    display: "flex",
    flexDirection: "column",
    fontFamily: "'Georgia', serif",
  },
  scrollable: {
    flex: 1,
    overflowY: "auto",
    overflowX: "hidden",
  },
};
