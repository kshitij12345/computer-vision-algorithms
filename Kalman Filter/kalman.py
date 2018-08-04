import cv2
import numpy as np

def segment_image(frame):
    gray=cv2.cvtColor(frame,cv2.COLOR_BGR2GRAY)
    contours=cv2.findContours(gray.copy(),cv2.RETR_TREE,cv2.CHAIN_APPROX_SIMPLE)
    largest=max(contours[1], key=cv2.contourArea)
    x, y, w, h = cv2.boundingRect(largest)
    cv2.rectangle(frame, (x, y), (x+w, y+h), (0, 255, 0), 2)
    #print(largest)
    cv2.drawContours(frame, [largest], 0, (0,0,255),3)
    return (x+(w/2.0),y+(h/2.0),w,h)
    
class KalmanFilter:
    def __init__(self,xk):
        self.timestep=1
        self.A=np.matrix([[1,0,self.timestep,0],[0,1,0,self.timestep],[0,0,1,0],[0,0,0,1]])
        self.H=np.matrix([[1,0,0,0],[0,1,0,0]])
        self.Q=np.matrix([[1,0,0,0],[0,10,0,0],[0,0,20,0],[0,0,0,10]])*0.01
        self.R=np.matrix([[0.01,0],[0,20000]])*0.0001
        self.P=np.matrix(np.eye(4))
        self.PP=[]
        self.xk=xk
        
    def predict_and_update(self,z):
        xp=self.A*np.matrix(self.xk)
        self.PP=self.A*self.P*self.A.transpose()+self.Q
        xpred=xp.transpose()
    
        K=self.P*self.H.transpose()*np.linalg.inv(self.H*self.PP*self.H.transpose()+self.R)
        self.P=(np.matrix(np.eye(4))-K*self.H)*self.PP
        self.xk=xp+K*(z.transpose()-self.H*xp)
        return xpred
        
        cap = cv2.VideoCapture('1.mp4')

k=KalmanFilter(np.matrix([0,0,0,0]).transpose())

while(cap.isOpened()):
    ret, frame = cap.read()
        
    bbox=segment_image(frame)
    x=np.matrix([bbox[0],bbox[1]])
    pred=k.predict_and_update(x)
    frame=np.zeros(frame.shape)
    cv2.circle(frame,(int(bbox[0]),int(bbox[1])),5,(0,0,255))
    cv2.circle(frame,(int(pred[0,0]),int(pred[0,1])),5,(0,255,0))
    cv2.imshow('frame',frame)
    cv2.waitKey(0)
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()
