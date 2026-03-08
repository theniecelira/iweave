export default function StarRating({ rating, max = 10, size = 11 }) {
  const stars = Math.round((rating / max) * 5);
  return (
    <span style={{ fontSize: size, color: "#FFB300" }}>
      {"★".repeat(stars)}
      {"☆".repeat(5 - stars)}
    </span>
  );
}
