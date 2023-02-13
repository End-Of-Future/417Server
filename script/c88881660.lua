--雾都重装兵械 生存维系者
function c88881660.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c88881660.lcheck)
	c:EnableReviveLimit()
	--extra material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(c88881660.matval) 
	e1:SetCondition(c88881660.matcon)
	c:RegisterEffect(e1)
	--disable summon
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SUMMON)
	e2:SetProperty(EFFECT_FLAG_NO_TURN_RESET) 
	e2:SetCountLimit(1)
	e2:SetCondition(c88881660.disscon) 
	e2:SetTarget(c88881660.disstg)
	e2:SetOperation(c88881660.dissop)
	c:RegisterEffect(e2)
	local e3=e2:Clone() 
	e3:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e3) 
	local e4=e2:Clone() 
	e4:SetCode(EVENT_FLIP_SUMMON) 
	c:RegisterEffect(e4)  
	--to deck 
	local e5=Effect.CreateEffect(c) 
	e5:SetCategory(CATEGORY_TODECK) 
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e5:SetCode(EVENT_LEAVE_FIELD) 
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP) 
	e5:SetTarget(c88881660.tdtg) 
	e5:SetOperation(c88881660.tdop) 
	c:RegisterEffect(e5) 
end
function c88881660.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x888)
end
function c88881660.matval(e,lc,mg,c,tp)
	if e:GetHandler()~=lc then return false,nil end
	return true,not mg or not mg:IsExists(Card.IsControler,1,nil,1-tp)
end
function c88881660.mckfil(c) 
	return c:IsFaceup() and c:IsSetCard(0x888)	
end 
function c88881660.matcon(e) 
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c88881660.mckfil,tp,LOCATION_MZONE,0,1,nil)  
end 
function c88881660.disscon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and Duel.GetCurrentChain()==0
end 
function c88881660.disstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c88881660.dissop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
end
function c88881660.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,PLAYER_ALL,LOCATION_ONFIELD) 
end 
function c88881660.tdop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil) 
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT) 
	end 
end 





