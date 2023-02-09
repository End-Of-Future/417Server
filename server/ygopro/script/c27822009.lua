--激流之旋涡
function c27822009.initial_effect(c)
   --Activate 
   local e1=Effect.CreateEffect(c) 
   e1:SetCategory(CATEGORY_TOGRAVE) 
   e1:SetType(EFFECT_TYPE_ACTIVATE)  
   e1:SetCode(EVENT_FREE_CHAIN)
   e1:SetProperty(EFFECT_FLAG_CARD_TARGET) 
   e1:SetCountLimit(1,27822009) 
   e1:SetTarget(c27822009.actg) 
   e1:SetOperation(c27822009.acop) 
   c:RegisterEffect(e1)  
end
c27822009.XXSplash=true  
function c27822009.xxfil(c,e,tp) 
   return c.XXSplash and c:IsType(TYPE_EFFECT) and Duel.IsExistingMatchingCard(c27822009.tgfil,tp,LOCATION_DECK,0,1,nil,e,tp,c) 
end 
function c27822009.tgfil(c,e,tp,sc) 
   return not c:IsCode(sc:GetCode()) and c:IsAbleToGrave() and c:IsType(TYPE_MONSTER) and c.XXSplash
end 
function c27822009.actg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
   if chk==0 then return Duel.IsExistingTarget(c27822009.xxfil,tp,LOCATION_MZONE,0,1,nil,e,tp) end 
   Duel.SelectTarget(tp,c27822009.xxfil,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
   Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end 
function c27822009.stfil(c) 
   return c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) and c:IsSSetable() and c.XXSplash  
end 
function c27822009.acop(e,tp,eg,ep,ev,re,r,rp) 
   local c=e:GetHandler() 
   local tc=Duel.GetFirstTarget() 
   local g=Duel.GetMatchingGroup(c27822009.tgfil,tp,LOCATION_DECK,0,nil,e,tp,tc) 
   if g:GetCount()>0 then 
	  local sg=g:Select(tp,1,1,nil) 
	  Duel.SendtoGrave(sg,REASON_EFFECT) 
	  if Duel.IsExistingMatchingCard(c27822009.stfil,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(27822009,1)) then 
	  local sc=Duel.SelectMatchingCard(tp,c27822009.stfil,tp,LOCATION_DECK,0,1,1,nil):GetFirst() 
	  if Duel.SSet(tp,sc)==0 then return end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e1) 
	  end 
   end  
end 


















