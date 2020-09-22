// Create "real" analogs.
//   TRealPoint instead of TPoint
//   TRealRect instead of TRect
//   RealPoint instead of Point
//   RealRect instead of Rect
//
//  efg, January 1999.
// Lovetskiy K.P. Modified February 2001 for Ellipse and Arc.

UNIT MapWorldToPixel;

INTERFACE

  USES
    WinTypes,    // TRect, TPoint
    Graphics;    // TCanvas

  // Define "Real" analogs to TPoint and TRect
  TYPE
    TReal = Double;

    TRealPoint =
    RECORD
      x:  TReal;
      y:  TReal
    END;

    TRealRect =
    RECORD
      CASE Integer OF
        0:  (Left, Top, Right, Bottom:  TReal);
        1:  (TopLeft, BottomRight:  TRealPoint)
    END;

    TSimplePantograph =
    CLASS(TObject)
      PRIVATE
        FCanvas   :  TCanvas;

        FPixelRect:  TRect;
        FRealRect :  TRealRect;

        FxDelta   :  TReal;
        FyDelta   :  TReal;
        FiDelta   :  INTEGER;
        FjDelta   :  INTEGER;

        FiDeltaOverxDelta:  TReal;
        FjDeltaOveryDelta:  TReal;

        FxDeltaOveriDelta:  TReal;
        FyDeltaOverjDelta:  TReal;


      PUBLIC
        CONSTRUCTOR Create(Canvas:  TCanvas; PixelRect:  TRect; RealRect:  TRealRect);

        // Could make these functions but don't always want to use .x and .y
        // to access fields.
        PROCEDURE MapRealToPixel(CONST x,y:  TReal;   VAR i,j:  INTEGER);
        PROCEDURE MapPixelToReal(CONST i,j:  INTEGER; VAR x,y:  TReal);

        PROCEDURE MoveTo(CONST x,y:  TReal);
        PROCEDURE LineTo(CONST x,y:  TReal);
        PROCEDURE Ellipse(CONST x1,y1, x2,y2:  TReal);
        PROCEDURE Arc(CONST x1,y1, x2,y2, x3,y3, x4,y4:  TReal);

        PROPERTY Canvas:  TCanvas  READ FCanvas;
    END;

    FUNCTION RealPoint(CONST aX, aY:  DOUBLE):  TRealPoint;
    FUNCTION RealRect(CONST aLeft, aTop, aRight, aBottom:  DOUBLE):  TRealRect;


IMPLEMENTATION

  USES
    SysUtils;  // Exception

  TYPE
    ESimplePantographError = CLASS(Exception);

  FUNCTION RealPoint(CONST aX, aY:  DOUBLE):  TRealPoint;
  BEGIN
    WITH RESULT DO
    BEGIN
      X := aX;
      Y := aY
    END
  END {RealPoint};

  FUNCTION RealRect(CONST aLeft, aTop, aRight, aBottom:  DOUBLE):  TRealRect;
  BEGIN
    WITH RESULT DO
    BEGIN
      Left   := aLeft;
      Top    := aTop;    // Switch top and bottom in "world coordinates"
      Right  := aRight;
      Bottom := aBottom  // Switch top and bottom in "world coordinates"
    END
  END {RealRect};


  CONSTRUCTOR TSimplePantograph.Create(Canvas:  TCanvas;
                                       PixelRect:  TRect; RealRect:  TRealRect);
  BEGIN
    FCanvas := Canvas;

    FPixelRect := PixelRect;
    FRealRect  := RealRect;

    FiDelta := PixelRect.Right  - PixelRect.Left;
    FjDelta := PixelRect.Bottom - PixelRect.Top;

    FxDelta := RealRect.Right   - RealRect.Left;
    FyDelta := RealRect.Top     - RealRect.Bottom;

    IF   (FiDelta = 0)   OR (FjDelta = 0)
    THEN RAISE ESimplePantographError.Create('Invalid Rectangle');

    IF   (FxDelta = 0.0) OR (FyDelta = 0.0)
    THEN RAISE ESimplePantographError.Create('Invalid Real Rectangle');

    FxDeltaOveriDelta := FxDelta / FiDelta;
    FyDeltaOverjDelta := FyDelta / FjDelta;

    FiDeltaOverxDelta := FiDelta / FxDelta;
    FjDeltaOveryDelta := FjDelta / FyDelta
  END {Create};


  PROCEDURE TSimplePantograph.MapRealToPixel(CONST x,y:  TReal;  VAR i,j:  INTEGER);
  BEGIN
    i := ROUND( FPixelRect.Left   + (x - FRealRect.Left) * FiDeltaOverxDelta);
    j := ROUND( FPixelRect.Top    - (y - FRealRect.Top)  * FjDeltaOveryDelta)
  END {MapRealToPixel};


  PROCEDURE TSimplePantograph.MapPixelToReal(CONST i,j:  INTEGER; VAR x,y:  TReal);
  BEGIN
    x := FRealRect.Left + (i - FPixelRect.Left) * FxDeltaOveriDelta;
    y := FRealRect.Top  - (j - FPixelRect.Top)  * FyDeltaOverjDelta
  END {MapPixelToReal};


  PROCEDURE TSimplePantograph.MoveTo(CONST x,y:  TReal);
    VAR
      i,j:  INTEGER;
  BEGIN
    MapRealToPixel(x,y, i,j);
    FCanvas.MoveTo(i,j)
  END {MoveTo};


  PROCEDURE TSimplePantograph.LineTo(CONST x,y:  TReal);
    VAR
      i,j:  INTEGER;
  BEGIN
    MapRealToPixel(x,y, i,j);
    FCanvas.LineTo(i,j)
  END {LineTo};


  PROCEDURE TSimplePantograph.Ellipse(CONST x1,y1, x2,y2:  TReal);
    VAR
      i1,i2:  INTEGER;
      j1,j2:  INTEGER;
  BEGIN
    MapRealToPixel(x1,y1, i1,j1);
    MapRealToPixel(x2,y2, i2,j2);
    FCanvas.Ellipse(i1,j1, i2,j2)
  END {Ellipse};


  PROCEDURE TSimplePantograph.Arc(CONST x1,y1, x2,y2, x3,y3, x4,y4:  TReal);
    VAR
      i1,i2,i3,i4:  INTEGER;
      j1,j2,j3,j4:  INTEGER;
  BEGIN
    MapRealToPixel(x1,y1, i1,j1);
    MapRealToPixel(x2,y2, i2,j2);
    MapRealToPixel(x3,y3, i3,j3);
    MapRealToPixel(x4,y4, i4,j4);
    FCanvas.Arc(i1,j1, i2,j2, i3,j3, i4,j4)
  END {Arc};

END.
