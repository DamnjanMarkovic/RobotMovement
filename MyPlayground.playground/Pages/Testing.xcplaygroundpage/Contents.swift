import UIKit

//MARK: - Permutation helper

func heapPermutation<T>(data: inout Array<T>, output: (Array<T>) -> Void) {
    generate(n: data.count, data: &data, output: output)
}

func generate<T>(n: Int, data: inout Array<T>, output: (Array<T>) -> Void) {
    if n == 1 {
        output(data)
    } else {
        for i in 0 ..< n {
            generate(n: n - 1, data: &data, output: output)
            if n % 2 == 0 {
                data.swapAt(i, n - 1)
            } else {
                data.swapAt(0, n - 1)
            }
        }
    }
}

//MARK: - Polymorph helper

func polymorphMove<T: MovementAction>(_ movingAction: T, movementDirection: MovementDirections, position: inout Position) {
    return movingAction.performAction(movementDirection: movementDirection, position: &position)
}

protocol MovementAction{
    func performAction(movementDirection: MovementDirections, position: inout Position)
}


struct MovementForward: MovementAction {
    
    func performAction(movementDirection: MovementDirections, position: inout Position)
    {
        switch movementDirection {
        case .East:
            position.onXAxis += 1
            break
        case .West:
            position.onXAxis -= 1
            break
        case .North:
            position.onYAxis += 1
            break
        case .South:
            position.onYAxis -= 1
            break
        }
    }
}

struct TurnClockwise: MovementAction {
    func performAction(movementDirection: MovementDirections, position: inout Position)
    {
        switch movementDirection {
        case .East:
            position.movementDirection = MovementDirections.North
            break
        case .West:
            position.movementDirection = MovementDirections.South
            break
        case .North:
            position.movementDirection = MovementDirections.West
            break
        case .South:
            position.movementDirection = MovementDirections.East
            break
        }
    }
}

struct TurnCounterClockWise: MovementAction {
    
    func performAction(movementDirection: MovementDirections, position: inout Position)
    {
        switch movementDirection {
        case .East:
            position.movementDirection = MovementDirections.South
            break
        case .West:
            position.movementDirection = MovementDirections.North
            break
        case .North:
            position.movementDirection = MovementDirections.East
            break
        case .South:
            position.movementDirection = MovementDirections.West
            break
        }
    }
}

//MARK: - Enums

enum Operation: Character {
    case P = "P"
    case L = "L"
    case D = "D"
}
enum MovementDirections{
    case North
    case East
    case South
    case West
}

//MARK: - Structs && Classes

struct Position {
    var onXAxis: Int = 0
    var onYAxis: Int = 0
    var movementDirection: MovementDirections = MovementDirections.North
}

// This struct calculates holds position and calculates relative moves as if position is performed from (0,0,↑)
// These moves will be used later
struct Movement {
    
    var position = Position(onXAxis: 0, onYAxis: 0, movementDirection: MovementDirections.North)
    
    mutating func getRelativeMovement(operations: String) -> Movement {
        
        for operation in operations {
        
            switch Operation(rawValue: operation) {
                case .P:
                    let _: () = polymorphMove(MovementForward(), movementDirection: position.movementDirection, position: &position)
                    break
                case .L:
                    let _: () = polymorphMove(TurnCounterClockWise(), movementDirection: position.movementDirection, position: &position)
                    break
                case .D:
                    let _: () = polymorphMove(TurnClockwise(), movementDirection: position.movementDirection, position: &position)
                    break
                default:
                    break
            }
        }
        return self
    }
}

final class Robot {
    
    //MARK: - Props
    var movements = [Movement]()
    var movementsPositions = [Int]()

    var operationsStrings = [String]()
    
    var counter = 0
    var text = "" //empty string improves performance?
    
    //MARK: - Funcs
    
    // Get strings from resources, and remove unnecessary characters in order to improve performance
    private final func setOperationsStrings() {
        
        let textArray = text.split(whereSeparator: \.isNewline)
        textArray.enumerated().forEach { (index, element) in
            if (index > 1) {
            
                if element.count >= 8 {
                    
                    // clean entries from useless characters:
                    // if LD or DL - can be removed
                    // if LLLL or DDDD - can be removed
                    // if PDPDPDPD or PLPLPLPL - can be removed
                    
                    var trimmedElement = element.replacingOccurrences(of: "LLLL", with: "")
                    trimmedElement = trimmedElement.replacingOccurrences(of: "DDDD", with: "")
                    trimmedElement = trimmedElement.replacingOccurrences(of: "LD", with: "")
                    trimmedElement = trimmedElement.replacingOccurrences(of: "DL", with: "")
                    trimmedElement = trimmedElement.replacingOccurrences(of: "PDPDPDPD", with: "")
                    trimmedElement = trimmedElement.replacingOccurrences(of: "PLPLPLPL", with: "")

                    operationsStrings.append(trimmedElement)
                }
                else {
                    operationsStrings.append(String(element))
                }
            }
        }
    }
    
    // Provides list of relative movements based on read strings and list of positions which will be used for permutations
    private final func setOperations() {
        
        operationsStrings.enumerated().forEach { (index, movementInStringFormat) in
            var movement = Movement()
//            movement = movement.getRelativeMovement(operations: movementInStringFormat)
//            movement =
//            movements.append(movement)
            
            movementsPositions.append(index)
        }
    }
    
    var operationsPosition = ["0", "1", "2"]
    
    // Create permutations of positions of the movements
    private final func createPermutationsAndMoveRobot() {
        
        var position = Position(onXAxis: 0, onYAxis: 0, movementDirection: MovementDirections.North)

    // Create array which holds iterations of permutated positions of the operation strings
        
        heapPermutation(data: &operationsStrings) { result in
            
            
            result.enumerated().forEach { (element, index) in

//                print(result)
                
//            if (element == 0) {
//                position = Position(onXAxis: 0, onYAxis: 0, movementDirection: MovementDirections.North)
//            }
//
//            var move = Movement(position: <#T##Position#>)
//            position = moveRobot(move: movements[Int(index)!], previousPosition: position, previousDirection: position.movementDirection)
            }
//
//            if (position.onXAxis == 0 && position.onYAxis == 0) { counter += 1 }
        }
    }
//
//    final func moveRobotStepByStep(move: Operation, previousPosition: Position, previousDirection: MovementDirections) -> MovementDirections {
//        var moveOnX = 0
//        var moveOnY = 0
//        var directionReturning = MovementDirections.North
//
//        switch previousDirection {
//            case .East:
//
//            switch move {
//            case .P:
//                moveOnX = previousPosition.onXAxis + 1
//                moveOnY = previousPosition.onYAxis - 1
//                break
//            case .D:
//                break
//            case .L:
//                break
//
//
//                moveOnX = previousPosition.onXAxis + move.position.onYAxis
//                moveOnY = previousPosition.onYAxis - move.position.onXAxis
//                switch move {
//                        case .North:
//                            directionReturning = MovementDirections.East
//                            break
//                        case .South:
//                            directionReturning = MovementDirections.West
//                            break
//                        case .East:
//                            directionReturning = MovementDirections.South
//                            break
//                        case .West:
//                            directionReturning = MovementDirections.North
//                            break
//                }
//                break
//            case .West:
//                moveOnX = previousPosition.onXAxis - move.position.onYAxis
//                moveOnY = previousPosition.onYAxis + move.position.onXAxis
//                switch move.position.movementDirection {
//                        case .North:
//                            directionReturning = MovementDirections.West
//                            break
//                        case .South:
//                            directionReturning = MovementDirections.East
//                            break
//                        case .East:
//                            directionReturning = MovementDirections.North
//                            break
//                        case .West:
//                            directionReturning = MovementDirections.South
//                            break
//                }
//                break
//            case .North:
//                moveOnX = previousPosition.onXAxis + move.position.onXAxis
//                moveOnY = previousPosition.onYAxis + move.position.onYAxis
//                directionReturning = move.position.movementDirection
//                break
//            case .South:
//                moveOnX = previousPosition.onXAxis - move.position.onXAxis
//                moveOnY = previousPosition.onYAxis - move.position.onYAxis
//                switch move.position.movementDirection {
//                        case .North:
//                            directionReturning = MovementDirections.South
//                            break
//                        case .South:
//                            directionReturning = MovementDirections.North
//                            break
//                        case .East:
//                            directionReturning = MovementDirections.West
//                            break
//                        case .West:
//                            directionReturning = MovementDirections.East
//                            break
//                }
//                break
//        }
//
//        return Position(onXAxis: moveOnX, onYAxis: moveOnY, movementDirection: directionReturning)
//    }
    
    // Move robot on the position received, using already created relative moves and position from the previous move
    final func moveRobot(move: Movement, previousPosition: Position, previousDirection: MovementDirections) -> Position {
        var moveOnX = 0
        var moveOnY = 0
        var directionReturning = MovementDirections.North
        
        switch previousDirection {
            case .East:
                moveOnX = previousPosition.onXAxis + move.position.onYAxis
                moveOnY = previousPosition.onYAxis - move.position.onXAxis
                switch move.position.movementDirection {
                        case .North:
                            directionReturning = MovementDirections.East
                            break
                        case .South:
                            directionReturning = MovementDirections.West
                            break
                        case .East:
                            directionReturning = MovementDirections.South
                            break
                        case .West:
                            directionReturning = MovementDirections.North
                            break
                }
                break
            case .West:
                moveOnX = previousPosition.onXAxis - move.position.onYAxis
                moveOnY = previousPosition.onYAxis + move.position.onXAxis
                switch move.position.movementDirection {
                        case .North:
                            directionReturning = MovementDirections.West
                            break
                        case .South:
                            directionReturning = MovementDirections.East
                            break
                        case .East:
                            directionReturning = MovementDirections.North
                            break
                        case .West:
                            directionReturning = MovementDirections.South
                            break
                }
                break
            case .North:
                moveOnX = previousPosition.onXAxis + move.position.onXAxis
                moveOnY = previousPosition.onYAxis + move.position.onYAxis
                directionReturning = move.position.movementDirection
                break
            case .South:
                moveOnX = previousPosition.onXAxis - move.position.onXAxis
                moveOnY = previousPosition.onYAxis - move.position.onYAxis
                switch move.position.movementDirection {
                        case .North:
                            directionReturning = MovementDirections.South
                            break
                        case .South:
                            directionReturning = MovementDirections.North
                            break
                        case .East:
                            directionReturning = MovementDirections.West
                            break
                        case .West:
                            directionReturning = MovementDirections.East
                            break
                }
                break
        }

        return Position(onXAxis: moveOnX, onYAxis: moveOnY, movementDirection: directionReturning)
    }
    
    // prints number of cases where final result is (0,0,↑)
    final func printNumberOfWantedPositions() {
        print(counter)
    }
    
    //MARK: - Initiation
    
    init(fileName: String) {
        
        //Read txt file from resources

        guard let fileURL = Bundle.main.url(forResource: fileName, withExtension: "txt") else { fatalError("File name is invalid") }
        do { text = try String(contentsOf: fileURL, encoding: .utf8) }
        catch {/* some error handling here */}
        
        setOperationsStrings()
        
        setOperations()
        createPermutationsAndMoveRobot()
        
    }

}


//var robot = Robot(fileName: "Test")           //should be 1
//var robot = Robot(fileName: "Test_03")        //should be 72
var robot = Robot(fileName: "Test_04")          //should be 38

robot.printNumberOfWantedPositions()


    







