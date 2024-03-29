% Render model:
function Mod = Render(Mod,X)

    [x1,y1] = Mod.GetPos(X,'m');

    if isempty(Mod.RenderObj) % Model hasn't been rendered yet


        % Render mass as circle
        Mod.RenderObj.m = DrawCircle(Mod, x1, y1, 1, Mod.m_radius, Mod.m_color, []);

        % Render links
        Mod.RenderObj.L = DrawLink(Mod, Mod.x0, Mod.y0, x1, y1, 0, []);
       
        
        % Finished rendering
        % Call function again to proceed with the code below
        Mod = Render(Mod,X);
    else
        
        % Model was already rendered - Re-draw links
        DrawCircle(Mod, x1, y1, 1, Mod.m_radius, Mod.m_color,Mod.RenderObj.m);
        DrawLink(Mod, Mod.x0, Mod.y0, x1, y1,0,Mod.RenderObj.L);

    end

    %         ~   Auxiliary nested functions ~      
    
    % Draw Circle:
    function [ res ] = DrawCircle(Mod, x, y, z, R, color,Obj)
        
        if isempty(Obj)
            
            coordX=zeros(1,Mod.CircRes);
            coordY=zeros(1,Mod.CircRes);
            coordZ=zeros(1,Mod.CircRes);

            for r=1:Mod.CircRes
                coordX(1,r)=R*cos(r/Mod.CircRes*2*pi);
                coordY(1,r)=R*sin(r/Mod.CircRes*2*pi);
                coordZ(1,r)=0;
            end

            res.Geom=patch(coordX,coordY,coordZ,color);
            set(res.Geom,'EdgeColor',color.^4);
            set(res.Geom,'LineWidth',2*Mod.LineWidth);
            
            res.Trans=hgtransform('Parent',gca);
            Txy=makehgtform('translate',[x y z]);
            
            set(res.Geom,'Parent',res.Trans);
            set(res.Trans,'Matrix',Txy);
            
        else
            
            Txy=makehgtform('translate',[x y z]);
            set(Obj.Trans,'Matrix',Txy); 
            
            res=1;          
        end
    end

    % Draw Link:
    % Draws a link of from (x0,y0) to (x1,y1)
    function [ res ] = DrawLink(Mod, x0, y0, x1, y1, z, Obj)
       
        if isempty(Obj)
            
            Length=sqrt((x1-x0)^2+(y1-y0)^2);
            Center=[(x0+x1)/2;
                    (y0+y1)/2];
            Orientation=atan2(y1-y0,x1-x0);

            res.Trans=hgtransform('Parent',gca);
            Txy=makehgtform('translate',[Center(1) Center(2) z]);
            Rz=makehgtform('zrotate',Orientation-pi/2);

            coordX=zeros(1,2*Mod.LinkRes+1);
            coordY=zeros(1,2*Mod.LinkRes+1);
            coordZ=zeros(1,2*Mod.LinkRes+1);

            x=0;
            y = Length/2-Mod.leg_width/2;
            
            for r=1:Mod.LinkRes
                coordX(1,r)=x+Mod.leg_width/2*cos(r/Mod.LinkRes*pi);
                coordY(1,r)=y+Mod.leg_width/2*sin(r/Mod.LinkRes*pi);
                coordZ(1,r)=0;
            end

            y = -Length/2+Mod.leg_width/2;
            
            for r=Mod.LinkRes:2*Mod.LinkRes
                coordX(1,r+1)=x+Mod.leg_width/2*cos(r/Mod.LinkRes*pi);
                coordY(1,r+1)=y+Mod.leg_width/2*sin(r/Mod.LinkRes*pi);
                coordZ(1,r+1)=0;
            end

            res.Geom=patch(coordX,coordY,coordZ,Mod.leg_color);
            set(res.Geom,'EdgeColor',[0 0 0]);
            set(res.Geom,'LineWidth',2*Mod.LineWidth);

            set(res.Geom,'Parent',res.Trans);
            set(res.Trans,'Matrix',Txy*Rz);
        else
            Center=[(x0+x1)/2;
                    (y0+y1)/2];
            Orientation=atan2(y1-y0,x1-x0);
            Length=sqrt((x1-x0)^2+(y1-y0)^2);

            Txy=makehgtform('translate',[Center(1) Center(2) z]);
            Rz=makehgtform('zrotate',Orientation-pi/2);
            Sx=makehgtform('scale',[Length/Mod.L,1,1]);
            set(Obj.Trans,'Matrix',Txy*Rz*Sx);
            res=1;
        end
    end


end