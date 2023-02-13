--王牌竞赛 幽灵
function c88880544.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xd88),2,4)
	--move  
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_INACTIVATE) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1,88880544) 
	e1:SetTarget(c88880544.mvtg) 
	e1:SetOperation(c88880544.mvop) 
	c:RegisterEffect(e1)  
	local e2=e1:Clone() 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	c:RegisterEffect(e2) 
	--Release 
	local e3=Effect.CreateEffect(c)  
	e3:SetCategory(CATEGORY_RELEASE)
	e3:SetType(EFFECT_TYPE_IGNITION) 
	e3:SetRange(LOCATION_MZONE) 
	e3:SetCountLimit(1,18880544) 
	e3:SetTarget(c88880544.rltg) 
	e3:SetOperation(c88880544.rlop) 
	c:RegisterEffect(e3) 
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DISABLE) 
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetTarget(c88880544.xdistg)
	c:RegisterEffect(e4)
end
function c88880544.mvtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local c=e:GetHandler()
	local zone=bit.band(c:GetLinkedZone(1-tp),0x1f) 
	if chk==0 then return eg:IsExists(Card.IsControler,1,nil,1-tp) and Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0,zone)>0 end 
end 
function c88880544.mvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local zone=bit.band(c:GetLinkedZone(1-tp),0x1f) 
	local g=eg:Filter(Card.IsControler,nil,1-tp):Filter(Card.IsOnField,nil) 
	if g:GetCount()>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0,zone)>0 then 
		local tc=g:Select(tp,1,1,nil):GetFirst() 
		local s=0
		local flag=bit.bxor(zone,0xff)*0x10000
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		s=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,flag)/0x10000
		local nseq=0
		if s==1 then nseq=0
		elseif s==2 then nseq=1
		elseif s==4 then nseq=2
		elseif s==8 then nseq=3
		else nseq=4 end
		Duel.MoveSequence(tc,nseq)
	end 
end 
function c88880544.rltg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rg=c:GetLinkedGroup():Filter(Card.IsReleasable,nil) 
	if chk==0 then return rg:GetCount()>0 end 
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,rg,rg:GetCount(),0,0) 
end 
function c88880544.rlop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local rg=c:GetLinkedGroup():Filter(Card.IsReleasable,nil) 
	local zone=bit.band(c:GetLinkedZone(1-tp),0x1f) 
	if rg:GetCount()>0 and Duel.Release(rg,REASON_EFFECT)~=0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0,zone)>0 and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_MZONE,1,nil) then 
		local tc=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_MZONE,1,1,nil):GetFirst() 
		local s=0
		local flag=bit.bxor(zone,0xff)*0x10000
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		s=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,flag)/0x10000
		local nseq=0
		if s==1 then nseq=0
		elseif s==2 then nseq=1
		elseif s==4 then nseq=2
		elseif s==8 then nseq=3
		else nseq=4 end
		Duel.MoveSequence(tc,nseq)
	end 
	if c:IsRelateToEffect(e) then  
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE) 
		e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(1) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end 
end 
function c88880544.xdistg(e,c) 
	return e:GetHandler():GetLinkedGroup():IsContains(c) 
end 











