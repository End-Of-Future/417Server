--五王圣魂-集结
function c27819066.initial_effect(c) 
	--xyz summon
	aux.AddXyzProcedure(c,c27819066.mfilter,5,2,nil,nil,5)
	c:EnableReviveLimit()
	--remove material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(27819066,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c27819066.xrmcon)
	e1:SetOperation(c27819066.xrmop)
	c:RegisterEffect(e1)	
	--indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetRange(LOCATION_MZONE) 
	e2:SetLabel(1)   
	e2:SetCondition(c27819066.excon)
	e2:SetValue(c27819066.indct)
	c:RegisterEffect(e2) 
	--atk&def  
	local e3=Effect.CreateEffect(c) 
	e3:SetType(EFFECT_TYPE_SINGLE) 
	e3:SetCode(EFFECT_SET_ATTACK)  
	e3:SetLabel(2)   
	e3:SetCondition(c27819066.excon)
	e3:SetValue(c27819066.atkval)
	c:RegisterEffect(e3) 
	local e4=Effect.CreateEffect(c) 
	e4:SetType(EFFECT_TYPE_SINGLE) 
	e4:SetCode(EFFECT_SET_DEFENSE)  
	e4:SetLabel(2)   
	e4:SetCondition(c27819066.excon)
	e4:SetValue(c27819066.defval)
	c:RegisterEffect(e4)  
	--immune
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)  
	e5:SetLabel(3)
	e5:SetCondition(c27819066.excon)
	e5:SetValue(c27819066.efilter) 
	c:RegisterEffect(e5) 
	--extra att
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_EXTRA_ATTACK)
	e6:SetValue(4) 
	e6:SetCondition(c27819066.excon)
	c:RegisterEffect(e6) 
	--control 
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_CONTROL) 
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetCountLimit(1)
	e7:SetLabel(6)
	e7:SetRange(LOCATION_MZONE) 
	e7:SetCondition(c27819066.excon) 
	e7:SetTarget(c27819066.cltg) 
	e7:SetOperation(c27819066.clop)
	c:RegisterEffect(e7)
	--disable spsummon
	local e9=Effect.CreateEffect(c) 
	e9:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_REMOVE)
	e9:SetType(EFFECT_TYPE_QUICK_O)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCode(EVENT_SUMMON) 
	e9:SetCountLimit(1) 
	e9:SetLabel(5)
	e9:SetCondition(c27819066.excon) 
	e9:SetTarget(c27819066.dstg)
	e9:SetOperation(c27819066.dsop)
	c:RegisterEffect(e9)
	local e10=e9:Clone()
	e10:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e10)
	local e11=e9:Clone()
	e11:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e11) 
	--negate
	local e12=Effect.CreateEffect(c) 
	e12:SetCategory(CATEGORY_REMOVE)
	e12:SetType(EFFECT_TYPE_QUICK_O)
	e12:SetCode(EVENT_CHAINING)
	e12:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e12:SetRange(LOCATION_MZONE)
	e12:SetCountLimit(1) 
	e12:SetLabel(7)
	e12:SetCondition(c27819066.excon)  
	e12:SetTarget(c27819066.rmtg)
	e12:SetOperation(c27819066.rmop)
	c:RegisterEffect(e12)
end 
c27819066.SetCard_fiveking=true 
c27819066.SetCard_fivekingtmx=true 
function c27819066.mfilter(c) 
	return c.SetCard_fiveking   
end 
function c27819066.xrmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c27819066.xrmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetOverlayCount()>0 then
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	end
end 
function c27819066.ovckfil(c)  
	return c.SetCard_fiveking 
end 
function c27819066.excon(e) 
	return e:GetHandler():GetOverlayGroup():FilterCount(c27819066.ovckfil,nil)>=e:GetLabel()  
end 
function c27819066.indct(e,re,r,rp)
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
		return 1
	else return 0 end
end
function c27819066.atkval(e) 
	return e:GetHandler():GetBaseAttack()*2  
end 
function c27819066.defval(e) 
	return e:GetHandler():GetBaseDefense()*2  
end 
function c27819066.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c27819066.fuslimit(e,c,sumtype)
	return sumtype==SUMMON_TYPE_FUSION
end 
function c27819066.dstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return ep==1-tp and Duel.GetCurrentChain()==0 end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,eg:GetCount(),0,0)
end
function c27819066.dsop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Remove(eg,POS_FACEDOWN,REASON_EFFECT)
end 
function c27819066.cltg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,1-tp,LOCATION_MZONE) 
end 
function c27819066.clop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,nil) 
	if g:GetCount()>0 then 
	local tc=g:Select(tp,1,1,nil):GetFirst() 
	Duel.GetControl(tc,tp,PHASE_END,1)
	end 
end  
function c27819066.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c27819066.rmtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return rp==1-tp and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end 
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil) 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end 
function c27819066.rmop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil) 
	if g:GetCount()>0 then 
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end 
end 

 
